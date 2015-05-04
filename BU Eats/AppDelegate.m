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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"f5649e3f1b043e69f3fc32b03f4f06c80277c955"];
    
    UINavigationController *root = (UINavigationController *)self.window.rootViewController;
    [root pushViewController:[ETLocationsViewController new] animated:NO];
    return YES;
}

@end
