//
//  BUDiningMenu.m
//  Gumbo
//
//  Created by Justin Paul on 4/25/15.
//  Copyright (c) 2015 WireIron. All rights reserved.
//

#import "BUDiningMenu.h"
#import "ObjectiveGumbo.h"
#import "ETLocation.h"

#define kDayYearMonth (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear)

const NSUInteger kPenland     = 1047;
const NSUInteger kMemorial    = 1045;
const NSUInteger kEastVillage = 6524;
const NSUInteger kBrooks      = 6523;

NSString * const kMenuURL = @"https://baylor.campusdish.com/Commerce/Catalog/Menus.aspx?LocationId=";

NSUInteger const kEateryCount = 4;

NSArray * ETEateries() {
    static NSArray *eateries = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Create all location objects
        NSArray<NSNumber *> *enums = @[@(EateryPenland), @(EateryMemorial), @(EateryEastVillage), @(EateryBrooks)];
        eateries = [enums mapped:^id(NSNumber *e, NSUInteger idx) {
            return [ETLocation location:e.integerValue];
        }];
    });

    return eateries;
}

NSString * ETStringFromEatery(BaylorEatery e) {
    switch (e) {
        case EateryPenland:
            return @"Penland";
        case EateryMemorial:
            return @"Memorial";
        case EateryEastVillage:
            return @"East Village";
        case EateryBrooks:
            return @"Brooks";
    }

    return nil;
}

NSString * ETMessageForEatery(BaylorEatery e) {
    switch (e) {
        case EateryPenland:
            return @"Typical hours:\n7–10 AM, 10:45–3 PM, 4:30–7:30, 8–12:30 AM";
        case EateryMemorial:
            return @"Typical hours:\n7 AM to 8 PM";
        case EateryEastVillage:
            return @"Typical hours:\n7–10 AM, 10:45–3 PM, 4:30–8:30 PM";
        case EateryBrooks:
            return @"Typical hours:\n7–10 AM, 11–2 PM 5–8 PM\n(no dinner on Friday)";
    }

    return nil;
}

NSString * ETHoursForEatery(BaylorEatery e) {
    switch (e) {
        case EateryPenland:
            return @"Weekdays: 7–10 AM, 10:45–3 PM, 4:30–7:30 PM\nLate night: 8–12:30 PM, except Fridays\nSaturday: 10:30-7 PM\nSunday: 10:30-2 PM, 5-7:30 PM";
        case EateryMemorial:
            return @"Weekdays: 7 AM to 8 PM\nClosed on weekends";
        case EateryEastVillage:
            return @"Weekdays: 7–10 AM, 10:45–3 PM, 4:30–8:30 PM\nClosed on Saturday\nSunday: 5-9 PM";
        case EateryBrooks:
            return @"Weekdays: 7–10 AM, 11–2 PM, and 5–8 PM\nFriday: same but no dinner\nClosed on weekends";
    }

    return nil;
}

NSString * NSStringFromMeal(Meal m) {
    switch (m) {
        case MealBreakfast:
            return @"Breakfast";
        case MealLunch:
            return @"Lunch";
        case MealDinner:
            return @"Dinner";
    }

    return nil;
}

Meal MealFromNSString(NSString *m) {
    if ([m isEqualToString:@"Breakfast"])
        return MealBreakfast;
    if ([m isEqualToString:@"Lunch"])
        return MealLunch;
    if ([m isEqualToString:@"Dinner"])
        return MealDinner;
    
    return NSNotFound;
}
