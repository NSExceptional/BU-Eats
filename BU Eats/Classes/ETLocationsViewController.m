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
#import "ETCreatedByViewController.h"
#import "ETHoursViewController.h"
#import "UIViewController+Extensions.h"

#import "ETLocation.h"
#import "ETTimeInterval.h"
#import "ETHOOP.h"


#pragma mark ETLocationsViewController
@interface ETLocationsViewController ()
@property (nonatomic) NSArray<ETLocation*> *locations;
@property (nonatomic) BOOL showingHours;
@end

@implementation ETLocationsViewController

- (id)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyTheme];
    
    self.title = @"Locations";
    #warning TODO translucency
//    self.navigationController.navigationBar.translucent = NO;

    // Table view config
    self.tableView.rowHeight = 112.f;
    [self.tableView registerNib:[UINib nibWithNibName:@"ETLocationCell" bundle:nil] forCellReuseIdentifier:@"LocationCell"];
    
    // Refresh control
    //    self.refreshControl = [UIRefreshControl new];
    //    [self.refreshControl addTarget:self action:@selector(loadHOOP) forControlEvents:UIControlEventValueChanged];
    
    UIButton *info = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [info addTarget:self action:@selector(showAboutPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *about = [[UIBarButtonItem alloc] initWithCustomView:info];
    self.navigationItem.leftBarButtonItem = about;
    UIBarButtonItem *hours = [[UIBarButtonItem alloc]
          initWithTitle:@"Hours"
          style:UIBarButtonItemStylePlain
          target:self
          action:@selector(showHours)
    ];
    self.navigationItem.rightBarButtonItem = hours;
    
    // Get location objects
    _locations = ETEateries();
    
    // TODO: fix this
    //    [self loadHOOP];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.showingHours = NO;
}

- (void)applyTheme {
    
}

- (void)showAboutPage {
    [self presentViewControllerModally:[ETCreatedByViewController new]];
}

- (void)showHours {
    self.showingHours = YES;
    [self presentViewControllerModally:[ETHoursViewController new]];
}

- (void)showLocation:(Eatery)eatery {
    if (self.showingHours) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kETModalsShouldDismissNotification object:nil];
    }

    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:NO];
    }

    ETMealTabController *meals = [ETMealTabController mealsForLocation:eatery];
    [self.navigationController pushViewController:meals animated:YES];
}

- (void)presentViewControllerModally:(UIViewController *)vc {
    UINavigationController *nav    = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barTintColor = [UIColor barBackgroundColors];
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
                    [locations addObject:[ETLocation location:e openIntervals:[hoop hoopForEatery:e]]];
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
    
    // Update data source and refresh
    _locations = ETEateries();
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    });
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETLocationCell *cell        = (ETLocationCell *)[self.tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    ETLocation *location        = self.locations[indexPath.row];
    cell.locationNameLabel.text = location.name;
    cell.statusLabel.text       = location.message;
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
