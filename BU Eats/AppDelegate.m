//
//  AppDelegate.m
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//
 
#import "AppDelegate.h"
#import "ETLocationsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *root = (UINavigationController *)self.window.rootViewController;
    [root pushViewController:[ETLocationsViewController new] animated:NO];
    return YES;
}

@end
