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

#define stringByTrimmingWhitespace stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
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
        NSMutableArray *locations = [NSMutableArray new];
        for (Eatery e = 1; e <= kEateryCount; e++) {
            [locations addObject:[ETLocation location:e]];
        }

        eateries = locations.copy;
    });

    return eateries;
}

NSString * ETStringFromEatery(Eatery e) {
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

NSString * ETMessageForEatery(Eatery e) {
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
}

NSString * ETHoursForEatery(Eatery e) {
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

static NSMutableDictionary *todayCache = nil;
static NSDateFormatter *formatter = nil;

+ (void)initialize {
    if (self == [BUDiningMenu class]) {
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        [self clearOldCacheEntries];
        [self loadTodaysCache];
    }
}

+ (void)clearOldCacheEntries {
    NSMutableArray *toRemove = [NSMutableArray array];

    // Get all plist files in cache directory
    NSArray *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectory] error:nil] ?: @[];
    items = [items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *item, NSDictionary *bindings) {
        return [item.pathExtension isEqualToString:@"plist"];
    }]];

    NSDate *today = [NSDate date].dateAtStartOfDay;
    for (NSString *item in items) {
        // Parse out date
        NSRange r = [item rangeOfString:@"_"];
        NSString *dateID = [item substringToIndex:r.location];
        NSDate *date = [formatter dateFromString:dateID];

        // Remove if today is after that date.
        if ([today daysAfterDate:date] > 0) {
            [toRemove addObject:item];
        }
    }

    // Delete old entries
    for (NSString *item in toRemove) {
        NSString *path = [[self cacheDirectory] stringByAppendingPathComponent:item];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (void)loadTodaysCache {
    todayCache = [NSMutableDictionary dictionary];

    // Get all dining hall names
    NSDate *today = [NSDate date];
    NSArray *names = @[
        ETStringFromEatery(EateryPenland),
        ETStringFromEatery(EateryEastVillage),
        ETStringFromEatery(EateryMemorial),
        ETStringFromEatery(EateryBrooks),
    ];

    // Load the file at "/cache/dir/DATETODAY-HALL.plist"
    for (NSString *name in names) {
        NSString *filename = [self filenameGiven:name onDate:today];
        NSString *path = [[self cacheDirectory] stringByAppendingPathComponent:filename];
        NSDictionary *meals = [NSDictionary dictionaryWithContentsOfFile:path];

        // Add to cache
        if (meals) {
            todayCache[name] = meals;
        }
    }
}

/// Filename for an entry is like "2018-02-01_Penland.plist"
+ (NSString *)filenameFor:(Eatery)location onDate:(NSDate *)date {
    return [self filenameGiven:ETStringFromEatery(location) onDate:date];
}

/// Filename for an entry is like "2018-02-01_Penland.plist"
+ (NSString *)filenameGiven:(NSString *)location onDate:(NSDate *)date {
    // Order matters for parsing
    NSString *formatted = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@_%@.plist", formatted, location];
}

+ (NSString *)cacheDirectory {
    static NSString *cacheDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    });

    return cacheDirectory;
}

+ (NSDictionary *)cachedMenuFor:(Eatery)location onDate:(NSDate *)date {
    // Check last cached
    static NSDictionary *lastCached = nil;
    static Eatery lastCachedEatery  = 0;
    static NSDate *lastCachedDate   = nil;
    if (lastCached && lastCachedEatery == location && [lastCachedDate isEqualToDateIgnoringTime:date]) {
        return lastCached;
    }

    // Check today's cache
    NSString *name = ETStringFromEatery(location);
    if (date.isToday && todayCache[name]) {
        return todayCache[name];
    }

    // Check disk
    NSString *path = [[self cacheDirectory] stringByAppendingPathComponent:[self filenameGiven:name onDate:date]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        lastCached = [NSDictionary dictionaryWithContentsOfFile:path];
        return lastCached;
    }

    return nil;
}

+ (void)cacheMenu:(NSDictionary *)menu for:(Eatery)location onDate:(NSDate *)date {
    // Compute filename and write to disk
    NSString *path = [[self cacheDirectory] stringByAppendingPathComponent:[self filenameFor:location onDate:date]];
    [menu writeToFile:path atomically:YES];
}

+ (void)menuFor:(Eatery)location onDate:(NSDate *)date completion:(FullMenuBlock)completion {
    NSParameterAssert(completion); NSParameterAssert(date);

    // Check cache first
    NSDictionary *cached = [self cachedMenuFor:location onDate:date];
    if (cached) {
        completion(cached, YES);
        return;
    }
    
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
            
            if (meals.count == 3) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Add menu to cache
                    [self cacheMenu:meals for:location onDate:date];
                    // Refresh today's cache if necessary
                    if (date.isToday) {
                        [self loadTodaysCache];
                    }

                    completion(meals.copy, NO);
                });
            }
        }];
    };
    
    loadMenus(@"Breakfast", MealBreakfast);
    loadMenus(@"Lunch", MealLunch);
    loadMenus(@"Dinner", MealDinner);
}

/// Note: never checks cache
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
