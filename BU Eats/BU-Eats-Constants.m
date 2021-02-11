//
//  BU-Eats-Constants.m
//  BU Eats
//
//  Created by Tanner on 8/2/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "BU-Eats-Constants.h"

NSString * const kHOOPURL = @"https://raw.githubusercontent.com/NSExceptional/BU-Eats/master/BUEats-HOOP.plist";
NSString * const kSchemaURL = @"https://raw.githubusercontent.com/NSExceptional/BU-Eats/master/BUEats-DOM-Schema.plist";
NSString * const kDefaultAllHoursURL = @"https://www.baylor.edu/hr/doc.php/151352.pdf";

NSString * const kHOOPWeekday  = @"weekday";
NSString * const kHOOPFriday   = @"friday";
NSString * const kHOOPSaturday = @"saturday";
NSString * const kHOOPSunday   = @"sunday";

NSString * const kETModalsShouldDismissNotification = @"kETModalsShouldDismissNotification";

NSString * const kAppShortcutHOOP        = @"com.pantsthief.BU-Eats.open_hoop";
NSString * const kAppShortcutPenland     = @"com.pantsthief.BU-Eats.open_penland";
NSString * const kAppShortcutEastVillage = @"com.pantsthief.BU-Eats.open_ev";
NSString * const kAppShortcutMemorial    = @"com.pantsthief.BU-Eats.open_memo";

NSString * const kETDefaultsFirstLaunchDate = @"BaylorEats.firstLaunch";
NSString * const kETDefaultsLastReviewDate = @"BaylorEats.lastReviewDate";

BOOL ETDeviceIsSmall() {
    return [UIScreen mainScreen].nativeBounds.size.height <= 1136;
}
