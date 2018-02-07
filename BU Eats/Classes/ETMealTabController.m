//
//  ETMealTabController.m
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETMealTabController.h"
#import "ETMenuViewController.h"

@interface ETMealTabController () <UITabBarControllerDelegate>
@property (nonatomic) Eatery location;
@property (nonatomic) NSDictionary *meals;
@property (nonatomic, readonly) UIActivityIndicatorView *spinner;
@property (nonatomic) BOOL loadingMeals;
@end

@implementation ETMealTabController

+ (instancetype)mealsForLocation:(Eatery)location {
    return [[ETMealTabController alloc] initWithLocation:location];
}

- (id)initWithLocation:(Eatery)location {
    _location = location;
    
    return [super init]; // calls viewDidLoad for some reason...
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = ETStringFromEatery(_location);
//    self.edgesForExtendedLayout = UIRectEdgeNone; // keeps views from going under nav bar
    self.tabBar.translucent = NO;

    self.delegate = self;

    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinner.color = [UIColor blackColor];
    self.spinner.center = ({
        CGPoint center = self.view.center;
        center.y += 20;
        center;
    });
    
    _datePicker = [[DIDatepicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.f)];
    [_datePicker setDates:[NSDate daysForTheNextMonth]];
    [_datePicker selectDateAtIndex:0];
    [_datePicker addTarget:self action:@selector(loadMeals) forControlEvents:UIControlEventValueChanged];
    
    ETMenuViewController *breakfast = [ETMenuViewController emptyMenuForLocation:self.location]; breakfast.title = @"Breakfast";
    ETMenuViewController *lunch     = [ETMenuViewController emptyMenuForLocation:self.location]; lunch.title     = @"Lunch";
    ETMenuViewController *dinner    = [ETMenuViewController emptyMenuForLocation:self.location]; dinner.title    = @"Dinner";
    
    [self setViewControllers:@[breakfast, lunch, dinner]];
    self.selectedIndex = 0;
    self.tabBar.items[0].title = @"Breakfast";
    self.tabBar.items[1].title = @"Lunch";
    self.tabBar.items[2].title = @"Dinner";
    
    self.tabBar.items[0].image = [UIImage imageNamed:@"Breakfast"];
    self.tabBar.items[1].image = [UIImage imageNamed:@"Lunch"];
    self.tabBar.items[2].image = [UIImage imageNamed:@"Dinner"];
    
    [self applyTheme];
    [self loadMeals];
}

- (void)applyTheme {
    self.tabBar.tintColor = [UIColor barBackgroundColors];
    _datePicker.selectedDateBottomLineColor = [UIColor barBackgroundColors];
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
    
    self.datePicker.enabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [BUDiningMenu menuFor:self.location onDate:self.datePicker.selectedDate completion:^(NSDictionary *fullMenu, BOOL cacheHit) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.loadingMeals = NO;

        [self setMeals:fullMenu animated:!cacheHit];
        self.datePicker.enabled = YES;
    }];
}

- (void)setLoadingMeals:(BOOL)loadingMeals {
    if (_loadingMeals == loadingMeals) return;

    _loadingMeals = loadingMeals;

    if (loadingMeals) {
        [self.spinner startAnimating];
        [self.view addSubview:self.spinner];
    } else {
        [self.spinner removeFromSuperview];
        [self.spinner stopAnimating];
    }
}

- (void)setMeals:(NSDictionary *)meals animated:(BOOL)animated {
    [meals enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSError class]]) {
            [self updateTabForMeal:key menu:@{} animated:animated];
            
            // Log show error
            if ([(NSError *)obj code] != 0) {
                [self failedToLoadMeal:key];
                NSLog(@"Failed to load meal: %@", key);
            } else {
                NSLog(@"Meal not being served: %@", key);
            }
        } else {
            [self updateTabForMeal:key menu:obj animated:animated];
        }
    }];
}

- (void)updateTabForMeal:(NSString *)mealKey menu:(NSDictionary *)menu animated:(BOOL)animated {
    NSUInteger idx = [self indexForMealKey:mealKey];
    ETMenuViewController *menuView;
    
    NSAssert(idx != NSNotFound, @"Missing view controller for meal key: %@", mealKey);

    menuView = self.viewControllers[idx];
    [menuView updateSections:menu.allKeys andItems:menu animated:animated];
}

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
    
    //    [alert showFromViewController:self];
}

- (void)failedToLoadMeal:(NSString *)meal {
    NSString *message = [NSString stringWithFormat:@"We couldn't load the menu for %@.", meal];
    TBAlertController *alert = [TBAlertController simpleOKAlertWithTitle:@"Uh-oh!" message:message];
    [alert showFromViewController:self];
}

@end
