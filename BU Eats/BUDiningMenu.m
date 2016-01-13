//
//  BUDiningMenu.m
//  Gumbo
//
//  Created by Justin Paul on 4/25/15.
//  Copyright (c) 2015 WireIron. All rights reserved.
//

#import "BUDiningMenu.h"
#import "ObjectiveGumbo.h"

#define stringByTrimmingWhitespace stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
#define kDayYearMonth (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear)

const NSUInteger kPenland     = 1047;
const NSUInteger kMemorial    = 1045;
const NSUInteger kEastVillage = 6524;
const NSUInteger kBrooks      = 6523;

const NSString *kMenuURL = @"https://baylor.campusdish.com/Commerce/Catalog/Menus.aspx?LocationId=";

NSUInteger const kEateryCount = 4;

NSString * NSStringFromEatery(Eatery e) {
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
}

NSString * NSMessageFromEatery(Eatery e) {
    switch (e) {
        case EateryPenland:
            return @"Open M-F from 7–10, 10:45–3, 4:30–7:30, and M-Th from 8–12:30 AM";
        case EateryMemorial:
            return @"Open 7 AM to 8 PM, M–F";
        case EateryEastVillage:
            return @"Open M-F from 7–10, 10:45–3, 4:30–8:30, and Sunday from 5 to 9 PM";
        case EateryBrooks:
            return @"Open M-F from 7–10, 11–2, and 5–8 (except on Fridays, no dinner)";
    }
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


@implementation BUDiningMenu

+ (void)menuFor:(Eatery)location onDate:(NSDate *)date completion:(FullMenuBlock)completion {
    NSParameterAssert(completion); NSParameterAssert(date);
    
    NSMutableDictionary *meals = [NSMutableDictionary new];
    
    void (^loadMenus)(NSString *mealName, Meal meal) = ^(NSString *mealName, Meal meal) {
        [self menuFor:location onDate:date forMeal:meal completion:^(NSError *error, NSDictionary *menu) {
            if (error)
                meals[mealName] = error;
            else if (menu) {
                meals[mealName] = menu;
            } else {
                meals[mealName] = [NSError errorWithDomain:@"Unknown error fetching menu" code:1 userInfo:nil];
            }
            
            if (meals.count == 3)
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(meals.copy);
                });
        }];
    };
    
    loadMenus(@"Breakfast", MealBreakfast);
    loadMenus(@"Lunch", MealLunch);
    loadMenus(@"Dinner", MealDinner);
}

+ (void)menuFor:(Eatery)location onDate:(NSDate *)date forMeal:(Meal)meal completion:(MenuBlock)completion {
    NSParameterAssert(location > 0);
    
    NSUInteger locationToSend;
    switch (location) {
        case EateryPenland:
            locationToSend = kPenland;
            break;
        case EateryMemorial:
            locationToSend = kMemorial;
            break;
        case EateryEastVillage:
            locationToSend = kEastVillage;
            break;
        case EateryBrooks:
            locationToSend = kBrooks;
            break;
    }
    
    NSString *mealToGet = NSStringFromMeal(meal);
    
    // Data for request
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kDayYearMonth fromDate:date];
    NSNumber *day   = @(components.day);
    NSNumber *month = @(components.month);
    NSNumber *year  = @(components.year);
    NSString *dateToSend = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    NSString *url = [NSString stringWithFormat:@"%@%lu%@%lu%@%@", kMenuURL, (unsigned long)locationToSend, @"&PeriodId=", (unsigned long)meal, @"&MenuDate=", dateToSend];
    
    // Send request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OGNode *data = [ObjectiveGumbo parseDocumentWithUrl:[NSURL URLWithString:url]];
        NSMutableArray *mealsBeingServed = [NSMutableArray new];
        for (OGElement *name in [data elementsWithClass:@"menu-period"])
            [mealsBeingServed addObject:name.text];
        
        if (![mealsBeingServed containsObject:mealToGet]) {
            NSString *domain = [NSString stringWithFormat:@"%@ is not being served.", NSStringFromMeal(meal)];
            completion([NSError errorWithDomain:domain code:0 userInfo:@{@"url":url}], nil);
            return;
        }
        
        NSArray *stationsElements = [data elementsWithClass:@"menu-details-station"];
        NSMutableDictionary *menu = [NSMutableDictionary new];
        
        for (OGElement *station in stationsElements) {
            NSString *stationName     = [[station elementsWithTag:[OGUtility gumboTagForTag:@"h2"]][0] text];
            NSArray *foodElements     = [station elementsWithClass:@"menu-name"];
            NSMutableArray *foodNames = [NSMutableArray new];
            
            for (OGElement *food in foodElements)
                [foodNames addObject:[food.text stringByTrimmingWhitespace]];
            
            if (foodNames.count > 0)
                menu[stationName] = foodNames;
        }
        
        if (!data || menu.count == 0) {
            NSLog(@"%@",data.description);
            completion([NSError errorWithDomain:@"Unknown error fetching menu" code:1 userInfo:@{@"url":url}], nil);
        }
        else
            completion(nil, menu);
    });
}

@end
