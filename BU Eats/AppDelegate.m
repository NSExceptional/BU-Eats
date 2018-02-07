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

#import <Crashlytics/Crashlytics.h>

@import StoreKit;

@interface AppDelegate ()
@property (nonatomic) ETLocationsViewController *locationsVC;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"f5649e3f1b043e69f3fc32b03f4f06c80277c955"];

    [self applyTheme];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.locationsVC = [ETLocationsViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.tintColor = [UIColor globalTint];
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
    if (@available(iOS 10.3, *)) if ([firstLaunch daysBeforeDate:today] > 2) {
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
    [UIApplication sharedApplication].statusBarStyle = [UIColor statusBarStyle];
    [UINavigationBar appearance].barTintColor = [UIColor barBackgroundColors];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor titleTextColor]};
    
    if (@available(iOS 11, *)) {
        [UINavigationBar appearance].prefersLargeTitles = !ETDeviceIsSmall();
        [UINavigationBar appearance].largeTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor titleTextColor]};
    }
}

@end
