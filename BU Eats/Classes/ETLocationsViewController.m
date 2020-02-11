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
@property (nonatomic) NSArray<CDEatery *> *locations;
@property (nonatomic) BOOL showingHours;
@end

@implementation ETLocationsViewController

+ (instancetype)locations:(NSArray<CDEatery *> *)locations {
    ETLocationsViewController *controller = [self new];
    controller.locations = locations;
    return controller;
}

- (id)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyTheme];
    
    self.title = @"Locations";

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

- (void)showLocation:(BaylorEatery)eatery {
    if (self.showingHours) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kETModalsShouldDismissNotification object:nil];
    }

    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:NO];
    }

    CDEatery *location = [self.locations filtered:^BOOL(CDEatery *loc, NSUInteger idx) {
        return loc.identifier.integerValue == eatery;
    }].firstObject;

    ETMealTabController *meals = [ETMealTabController mealsForLocation:location];
    [self.navigationController pushViewController:meals animated:YES];
}

- (void)presentViewControllerModally:(UIViewController *)vc {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : UIColor.titleTextColor };
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    if (@available(iOS 13, *)) {
        nav.navigationBar.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return UIColor.systemBackgroundColor;
            } else {
                return UIColor.barBackgroundColors;
            }
        }];
    } else {
        nav.navigationBar.backgroundColor = UIColor.barBackgroundColors;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETLocationCell *cell        = [self.tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    CDEatery *location          = self.locations[indexPath.row];
    cell.locationNameLabel.text = location.name;
    cell.statusLabel.text       = location.hours;
    cell.locationIcon.image     = [UIImage imageNamed:location.name];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ETMealTabController *meals = [ETMealTabController mealsForLocation:self.locations[indexPath.row]];
    [self.navigationController pushViewController:meals animated:YES];
}

@end
