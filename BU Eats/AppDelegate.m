//
//  AppDelegate.m
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "AppDelegate.h"
#import "TBAlertController.h"
#import "ETLocationsViewController.h"
#import "BUDiningMenu.h"
#import "CDClient.h"

@import StoreKit;

@interface AppDelegate ()
@property (nonatomic) ETLocationsViewController *locationsVC;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self applyTheme];
    
    CDClient.sharedClient.currentSchool = CDSchool.baylor;
    CDClient.sharedClient.currentEateries = CDEatery.baylorEateries;
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.tintColor = UIColor.globalTint;
    
    self.locationsVC = [ETLocationsViewController locations:CDClient.sharedClient.currentEateries];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.locationsVC];
    [self.window makeKeyAndVisible];

    [self maybeAskForRating];

    return YES;
}

- (void)application:(UIApplication *)app performActionForShortcutItem:(UIApplicationShortcutItem *)shortcut completionHandler:(void (^)(BOOL))completion {
    if ([shortcut.type isEqualToString:kAppShortcutHOOP]) {
        [self.locationsVC showHours];
    } else if ([shortcut.type isEqualToString:kAppShortcutPenland]) {
        [self.locationsVC showLocation:EateryPenland];
    } else if ([shortcut.type isEqualToString:kAppShortcutEastVillage]) {
        [self.locationsVC showLocation:EateryEastVillage];
    } else if ([shortcut.type isEqualToString:kAppShortcutMemorial]) {
        [self.locationsVC showLocation:EateryMemorial];
    }

    completion(YES);
}

- (void)maybeAskForRating {
    NSDate *firstLaunch    = [[NSUserDefaults standardUserDefaults] objectForKey:kETDefaultsFirstLaunchDate];
    NSDate *lastReviewDate = [[NSUserDefaults standardUserDefaults] objectForKey:kETDefaultsLastReviewDate];
    NSDate *today = [NSDate date].dateAtStartOfDay;

    if (!firstLaunch) {
        firstLaunch = today;
        [[NSUserDefaults standardUserDefaults] setObject:firstLaunch forKey:kETDefaultsFirstLaunchDate];
    }

    // Review 2 days after first launch, then again a week later
    if ([firstLaunch daysBeforeDate:today] > 2) {
        if ([lastReviewDate daysBeforeDate:today] > 7) {
            [SKStoreReviewController requestReview];
            [[NSUserDefaults standardUserDefaults] setObject:today forKey:kETDefaultsLastReviewDate];
        } else if (!lastReviewDate) {
            [SKStoreReviewController requestReview];
            [[NSUserDefaults standardUserDefaults] setObject:today forKey:kETDefaultsLastReviewDate];
        }
    }
}

- (void)applyTheme {
    NSDictionary *titleTextAttributes = @{ NSForegroundColorAttributeName : UIColor.titleTextColor };
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    [UIApplication sharedApplication].statusBarStyle = UIColor.statusBarStyle;
    appearance.barTintColor = UIColor.barBackgroundColors;
    appearance.titleTextAttributes = titleTextAttributes;
    appearance.prefersLargeTitles = !ETDeviceIsSmall();
    appearance.largeTitleTextAttributes = titleTextAttributes;
    appearance.translucent = NO;
    
    if (@available(iOS 13, *)) {
        UINavigationBarAppearance *defaults = [UINavigationBarAppearance new];
        [defaults configureWithOpaqueBackground];
        defaults.backgroundColor = UIColor.barBackgroundColors;
        defaults.titleTextAttributes = titleTextAttributes;
        defaults.largeTitleTextAttributes = titleTextAttributes;
        appearance.scrollEdgeAppearance = defaults;
        appearance.standardAppearance = defaults;
    }
}

@end
