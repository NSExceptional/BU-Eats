//
//  AppDelegate.m
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "AppDelegate.h"
#import "ETLocationsViewController.h"

#import <Crashlytics/Crashlytics.h>
#import "FLEXManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"f5649e3f1b043e69f3fc32b03f4f06c80277c955"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.tintColor = [UIColor globalTint];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ETLocationsViewController new]];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[FLEXManager sharedManager] action:@selector(showExplorer)];
//    tap.numberOfTouchesRequired = 3;
//    [self.window addGestureRecognizer:tap];
    
    return YES;
}

@end
