//
//  BU-Eats-Constants.h
//  BU Eats
//
//  Created by Tanner on 8/2/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NS_USE_SMALL_TsITLES_ON_SMALL_SCREENS(vc) if (@available(iOS 11, *)) { \
vc.navigationController.navigationBar.prefersLargeTitles = !ETDeviceIsSmall(); \
} \

#define NSIndexSetRanged(loc, len) [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, len)]

extern NSString * const kHOOPURL;
extern NSString * const kSchemaURL;
extern NSString * const kDefaultAllHoursURL;

extern NSString * const kHOOPWeekday;
extern NSString * const kHOOPFriday;
extern NSString * const kHOOPSaturday;
extern NSString * const kHOOPSunday;

extern NSString * const kETModalsShouldDismissNotification;

extern NSString * const kAppShortcutHOOP;
extern NSString * const kAppShortcutPenland;
extern NSString * const kAppShortcutEastVillage;
extern NSString * const kAppShortcutMemorial;

extern NSString * const kETDefaultsFirstLaunchDate;
extern NSString * const kETDefaultsLastReviewDate;

extern BOOL ETDeviceIsSmall(void);
