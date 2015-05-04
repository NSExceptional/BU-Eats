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
    [self.refreshControl addTarget:self action:@selector(updateHours) forControlEvents:UIControlEventValueChanged];
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
        [locations addObject:[ETLocation location:e openIntervals:[ETTimeInterval hoursOfOperationForLocation:e]]];
    
    _locations = locations.copy;
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

- (void)updateHours {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
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