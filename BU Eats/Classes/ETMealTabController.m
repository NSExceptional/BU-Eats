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
@end

@implementation ETMealTabController

+ (instancetype)mealsForLocation:(Eatery)location {
    return [[ETMealTabController alloc] initWithLocation:location];
}

- (id)initWithLocation:(Eatery)location {
    _location = location;
    
    self = [super init]; // calls viewDidLoad for some reason...
    if (self) {
        self.title = NSStringFromEatery(_location);
        self.edgesForExtendedLayout = UIRectEdgeNone; // keeps views from going under nav bar
        self.tabBar.translucent = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    _datePicker = [[DIDatepicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.f)];
    [_datePicker setDates:[NSDate daysForTheNextMonth]];
    [_datePicker selectDateAtIndex:0];
    [_datePicker addTarget:self action:@selector(loadMeals) forControlEvents:UIControlEventValueChanged];
    
    ETMenuViewController *breakfast = [ETMenuViewController emptyMenuForLocation:self.location]; breakfast.title = @"Breakfast";
    ETMenuViewController *lunch     = [ETMenuViewController emptyMenuForLocation:self.location]; lunch.title     = @"Lunch";
    ETMenuViewController *dinner    = [ETMenuViewController emptyMenuForLocation:self.location]; dinner.title    = @"Dinner";
    
    [self setViewControllers:@[breakfast, lunch, dinner]];
    self.selectedIndex = 0;
    [self.tabBar.items[0] setTitle:@"Breakfast"];
    [self.tabBar.items[1] setTitle:@"Lunch"];
    [self.tabBar.items[2] setTitle:@"Dinner"];
    
    [self.tabBar.items[0] setImage:[UIImage imageNamed:@"Breakfast"]];
    [self.tabBar.items[1] setImage:[UIImage imageNamed:@"Lunch"]];
    [self.tabBar.items[2] setImage:[UIImage imageNamed:@"Dinner"]];
    
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
    self.datePicker.enabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [BUDiningMenu menuFor:self.location onDate:self.datePicker.selectedDate completion:^(NSDictionary *fullMenu) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.meals = fullMenu;
        self.datePicker.enabled = YES;
    }];
}

- (void)setMeals:(NSDictionary *)meals {
    [meals enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSError class]]) {
            // Remove tab or show error
            if ([(NSError *)obj code] != 0) {
                [self failedToLoadMeal:key];
                NSLog(@"Failed to load meal: %@", key);
            }
            else {
                [self removeViewControllerForMealKey:key];
                NSLog(@"Remove tab, meal not being served: %@", key);
            }
        }
        else {
            // Update / add tab
            [self updateOrAddTabForMeal:key menu:obj];
        }
    }];
    NSLog(@"____________________________________________________\n");
}

- (void)updateOrAddTabForMeal:(NSString *)mealKey menu:(NSDictionary *)menu {
    NSUInteger idx = [self indexForMealKey:mealKey];
    ETMenuViewController *menuView;
    
    // Add tab
    if (idx == NSNotFound) {
        NSLog(@"Add tab for meal: %@", mealKey);
        menuView = [ETMenuViewController menuForLocation:self.location sections:menu.allKeys items:menu];
        [self setViewControllers:[self.viewControllers arrayByAddingObject:menuView] animated:YES];
        [self.tabBar.items[self.viewControllers.count-1] setTitle:mealKey];
        [self.tabBar.items[self.viewControllers.count-1] setImage:[UIImage imageNamed:mealKey]];
    }
    // Update existing tab
    else {
        NSLog(@"Update tab for meal: %@", mealKey);
        menuView = self.viewControllers[idx];
        [menuView updateSections:menu.allKeys andItems:menu];
    }
}

- (NSUInteger)indexForMealKey:(NSString *)key {
    NSMutableArray *titles = [NSMutableArray new];
    for (UITabBarItem *item in self.tabBar.items)
        [titles addObject:item.title];
    
    return [titles indexOfObject:key];
}

- (void)removeViewControllerForMealKey:(NSString *)key {
    NSUInteger idx = [self indexForMealKey:key];
    if (idx == NSNotFound)
        return;
    
    NSMutableArray *views = self.viewControllers.mutableCopy;
    [views removeObjectAtIndex:idx];
    [self setViewControllers:views animated:YES];
    
    if (views.count > 0)
        [self setSelectedIndex:0];
    else
        [self showNotOpenWarning];
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
