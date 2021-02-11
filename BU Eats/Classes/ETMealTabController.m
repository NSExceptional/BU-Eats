//
//  ETMealTabController.m
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETMealTabController.h"
#import "ETMenuViewController.h"
#import "CDClient.h"
#import "CDMenu.h"
#import "ETTimeInterval.h"
#import "UIColor+BU.h"

@interface ETMealTabController () <UITabBarControllerDelegate>
@property (nonatomic) CDEatery *eatery;
@property (nonatomic, readonly) UIActivityIndicatorView *spinner;
@property (nonatomic) BOOL loadingMeals;
@end

@implementation ETMealTabController

+ (instancetype)mealsForLocation:(CDEatery *)location {
    return [[ETMealTabController alloc] initWithLocation:location];
}

- (id)initWithLocation:(CDEatery *)eatery {
    _eatery = eatery;
    // Calls viewDidLoad for some reason, so we need to assign location first
    return [super init];
}

- (void)loadView {
    [super loadView];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _datePicker = [[DIDatepicker alloc]
        initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.f)
    ];
    
    self.spinner.color = UIColor.spinnerColor;
    self.spinner.center = ({
        CGPoint center = self.view.center;
        center.y += 20;
        center;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.eatery.name;
    self.delegate = self;
    
    // Without this, scrolling the table views makes the large title "snap" away
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.datePicker.dates = NSDate.daysForTheNextMonth;
    [self.datePicker selectDateAtIndex:0];
    [self.datePicker addTarget:self action:@selector(loadMeals) forControlEvents:UIControlEventValueChanged];

    self.viewControllers = [self.eatery.meals mapped:^id(CDMeal *meal, NSUInteger idx) {
        return [ETMenuViewController emptyMenuForLocation:self.eatery meal:meal];
    }];
    
    [self applyTheme];
    [self loadMeals];
}

- (void)applyTheme {
    self.tabBar.tintColor = UIColor.greenTint;
}

#pragma mark UITabBar stuff

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    super.selectedIndex = selectedIndex;
    [(UITableViewController *)self.viewControllers[selectedIndex] tableView].tableHeaderView = self.datePicker;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self assignDatePickerViewToTableViewController:(UITableViewController *)viewController];
}

- (void)assignDatePickerViewToTableViewController:(UITableViewController *)viewController {
    [self unassignDatePickerView];
    viewController.tableView.tableHeaderView = self.datePicker;
    self.datePicker.bottomLineColor = viewController.tableView.separatorColor;
}

- (void)unassignDatePickerView {
    for (UITableViewController *tablevc in self.viewControllers)
        tablevc.tableView.tableHeaderView = nil;
}

#pragma mark Data

- (void)loadMeals {
    self.loadingMeals = YES;

    // Clear sections
    for (ETMenuViewController *menu in self.viewControllers) {
        [menu clear];
    }

    // Disable date picker, show activity indicator
    self.datePicker.enabled = NO;

    // Load meals
    [[CDClient sharedClient] menuFor:self.eatery
                              onDate:self.datePicker.selectedDate
                          completion:^(CDMenu *menu, BOOL cacheHit, NSError *error) {
        self.loadingMeals = NO;
        if (!error) {
            [self setMenu:menu animated:!cacheHit];
            self.datePicker.enabled = YES;
        } else {
            [self failedToLoadMenu:error.localizedDescription];
        }
    }];
}

- (void)setLoadingMeals:(BOOL)loadingMeals {
    if (_loadingMeals == loadingMeals) return;

    _loadingMeals = loadingMeals;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = loadingMeals;

    if (loadingMeals) {
        [self.spinner startAnimating];
        [self.view addSubview:self.spinner];
    } else {
        [self.spinner removeFromSuperview];
        [self.spinner stopAnimating];
    }
}

- (void)setMenu:(CDMenu *)menu animated:(BOOL)animated {
    for (CDMealPeriod *meal in menu.meals) {
        // If there is an error, the meal period will have 0 stations
        [self updateTabForMeal:meal animated:animated];
        // Notify user on error
        if (meal.error) {
            [self failedToLoadMeal:meal.period.name];
        }
    }
}

- (void)updateTabForMeal:(CDMealPeriod *)meal animated:(BOOL)animated {
    NSUInteger idx = [self indexForMealKey:meal.period.name];
    ETMenuViewController *menuView;
    
    NSAssert(idx != NSNotFound, @"Missing view controller for meal key: %@", meal.period.name);

    menuView = self.viewControllers[idx];
    [menuView updateSections:meal.foodStations animated:YES];
}

/// TODO this could be reworked to just take a CDMeal object and return the index of itself
- (NSUInteger)indexForMealKey:(NSString *)key {
    NSMutableArray *titles = [NSMutableArray new];
    for (UITabBarItem *item in self.tabBar.items) {
        [titles addObject:item.title];
    }
    
    return [titles indexOfObject:key];
}

- (void)showNotOpenWarning {
    TBAlertController *alert = [TBAlertController alertViewWithTitle:nil message:@"Looks like this dining hall isn't open today."];
    [alert addOtherButtonWithTitle:@"OK" buttonAction:^(NSArray *textFieldStrings) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert showFromViewController:self];
}

- (void)failedToLoadMeal:(NSString *)meal {
    NSString *message = [NSString stringWithFormat:@"We couldn't load the menu for %@.", meal];
    TBAlertController *alert = [TBAlertController simpleOKAlertWithTitle:@"Uh-oh!" message:message];
    [alert showFromViewController:self];
}

- (void)failedToLoadMenu:(NSString *)error {
    NSString *message = @"We couldn't load the menu.\nPlease send a screenshot of this to the developer:\n\n";
    message = [message stringByAppendingString:error];
    TBAlertController *alert = [TBAlertController simpleOKAlertWithTitle:@"Uh-oh :(" message:message];
    [alert showFromViewController:self];
}

@end
