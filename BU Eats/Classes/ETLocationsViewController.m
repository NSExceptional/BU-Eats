//
//  ETLocationsViewController.m
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETLocationsViewController.h"
#import "ETLocationCell.h"
#import "ETMealTabController.h"

#import "ETLocation.h"
#import "ETTimeInterval.h"
#import "ETHOOP.h"

#pragma mark Dismiss view controller category
@interface UIViewController (Dismiss)
- (void)dismissAnimated;
@end
@implementation UIViewController (Dismiss)
- (void)dismissAnimated {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

#pragma mark ETLocationsViewController
@interface ETLocationsViewController ()
@property (nonatomic) NSArray *locations;
@end

@implementation ETLocationsViewController

- (id)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyTheme];
    
    self.title = @"Locations";
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadHOOP) forControlEvents:UIControlEventValueChanged];
    self.navigationController.navigationBar.translucent = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"ETLocationCell" bundle:nil] forCellReuseIdentifier:@"LocationCell"];
    self.tableView.rowHeight = 112.f;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(showAboutPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *about = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = about;
    
    // Create all location objects
    NSMutableArray *locations = [NSMutableArray new];
    for (Eatery e = 1; e <= kEateryCount; e++)
        [locations addObject:[ETLocation location:e openIntervals:@[] message:@"Loading…"]];
    
    _locations = locations.copy;
    
    [self loadHOOP];
}

- (void)applyTheme {
    [UIApplication sharedApplication].statusBarStyle = [UIColor statusBarStyle];
    self.navigationController.navigationBar.barTintColor = [UIColor barBackgroundColors];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor titleTextColor]};
}

- (void)showAboutPage {
    UIViewController *about = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"about"];
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:about action:@selector(dismissAnimated)];
    about.navigationItem.rightBarButtonItem = dismiss;
    about.title = @"About";
    
    UINavigationController *nav    = [[UINavigationController alloc] initWithRootViewController:about];
    nav.navigationBar.translucent  = NO;
    nav.navigationBar.barTintColor = [UIColor barBackgroundColors];
    nav.navigationBar.tintColor    = [UIColor globalTint];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor titleTextColor]};
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)loadHOOP {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Load plist data
        NSError *loadError = nil;
        NSData *plistData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kHOOPURL] options:0 error:&loadError];
        
        if (!loadError) {
            NSError *plistError = nil;
            ETHOOP *hoop = [ETHOOP fromData:plistData error:&plistError];
            if (!plistError) {
                
                // Create all location objects
                NSMutableArray *locations = [NSMutableArray array];
                for (Eatery e = 1; e <= kEateryCount; e++) {
                    [locations addObject:[ETLocation location:e openIntervals:[hoop hoopForEatery:e] message:hoop.messagesByEatery[NSStringFromEatery(e)]]];
                }
                
                // Update data source and refresh
                _locations = locations.copy;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    [self.refreshControl endRefreshing];
                });
            } else {
                [self handleLoadError:plistError];
            }
        } else {
            [self handleLoadError:loadError];
        }
    });
}

- (void)handleLoadError:(NSError *)error {
    [[TBAlertController simpleOKAlertWithTitle:@"Error loading locations' hours of operation. Default times shown." message:error.localizedDescription] showFromViewController:self];
    
    // Create all location objects
    NSMutableArray *locations = [NSMutableArray new];
    for (Eatery e = 1; e <= kEateryCount; e++)
        [locations addObject:[ETLocation location:e openIntervals:[ETTimeInterval hoursOfOperationForLocation:e] message:nil]];
    
    // Update data source and refresh
    _locations = locations.copy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    });
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETLocationCell *cell        = (ETLocationCell *)[self.tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    ETLocation *location        = self.locations[indexPath.row];
    cell.locationNameLabel.text = location.name;
    cell.statusLabel.text       = location.status;
    cell.locationIcon.image     = [UIImage imageNamed:location.name];
    if (!location.isOpen)
        cell.statusLabel.textColor = [UIColor colorWithRed:1.000 green:0.200 blue:0.200 alpha:1.000];
    else
        cell.statusLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ETMealTabController *meals = [ETMealTabController mealsForLocation:indexPath.row+1];
    [self.navigationController pushViewController:meals animated:YES];
}

@end