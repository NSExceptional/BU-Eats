//
//  CDClient.m
//  BU Eats
//
//  Created by Tanner on 9/4/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDClient.h"
#import "CDMenu.h"
#import "CDMeal.h"
#import <ObjectiveGumbo.h>
#import <TBURLRequestBuilder.h>
#import "OGDocument+JSON.h"

#define ParseDocument(data, sel, cls, block) [self parseDocument: data keyPath: @selector(sel) class: [cls class] completion: block]
#define kDayYearMonth (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear)

@interface CDClient ()
@end

@implementation CDClient

+ (instancetype)sharedClient {
    static CDClient *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self new];
    });

    return shared;
}

static NSMutableDictionary *todayCache = nil;
static NSDateFormatter *formatter = nil;

+ (void)initialize {
    if (self == [CDClient class]) {
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        [self clearOldCacheEntries];
        [self loadTodaysCache];
    }
}

/// Absolute paths to each cache entry
+ (NSArray<NSString*> *)allCacheEntries {
    NSString *cacheDir = [self cacheDirectory];
    NSArray<NSString *> *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDir error:nil] ?: @[];

    return [items mapped:^id(NSString *item, NSUInteger idx) {
        // Only plists
        if ([item.pathExtension isEqualToString:@"plist"]) {
            return [cacheDir stringByAppendingPathComponent:item];
        }

        return nil;
    }];
}

+ (void)clearOldCacheEntries {
    // Get all plist files in cache directory
    NSArray<NSString *> *items = [self allCacheEntries];

    // Filter by files starting with today's date
    // We (rightfully) assume there will be no caches for future dates,
    // so we don't have to construct NSDate objects and compare dates.
    // We just need to check for today's date and nothing else.
    NSString *todaysPrefix = [self datePrefixForFileOnDate:[NSDate date]];
    NSArray<NSString *> *toRemove = [items filtered:^BOOL(NSString *item, NSUInteger idx) {
        return [item.lastPathComponent hasPrefix:todaysPrefix];
    }];

    // Delete old entries
    for (NSString *itemPath in toRemove) {
        [[NSFileManager defaultManager] removeItemAtPath:itemPath error:nil];
    }
}

+ (void)loadTodaysCache {
    todayCache = [NSMutableDictionary dictionary];

    // Load all files at "/cache/dir/DATETODAY_EATERYID.plist"
    NSString *todaysPrefix = [self datePrefixForFileOnDate:[NSDate date]];
    for (NSString *filepath in [self allCacheEntries]) {
        // Like DATETODAY_EATERYID
        NSString *filename = filepath.lastPathComponent.stringByDeletingPathExtension;
        NSString *identifier = [filename componentsSeparatedByString:@"_"][1];
        NSAssert(identifier, @"Invalid cached filename");

        if ([filename hasPrefix:todaysPrefix]) {
            // Add to cache
            todayCache[identifier] = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
        }
    }
}

/// Filename for an entry is like "2018-02-01_location_id.plist"
+ (NSString *)filenameGiven:(NSString *)locationID onDate:(NSDate *)date {
    // Order matters for parsing
    NSString *formatted = [self datePrefixForFileOnDate:date];
    return [NSString stringWithFormat:@"%@_%@.plist", formatted, locationID];
}

+ (NSString *)datePrefixForFileOnDate:(NSDate *)date {
    return [formatter stringFromDate:date];
}

+ (NSString *)fullPathFor:(NSString *)locationID onDate:(NSDate *)date {
    return [[self cacheDirectory] stringByAppendingPathComponent:[self filenameGiven:locationID onDate:date]];
}

+ (NSString *)cacheDirectory {
    static NSString *cacheDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"MenuCache"];
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                  withIntermediateDirectories:YES attributes:nil error:nil];
    });

    return cacheDirectory;
}

+ (CDMenu *)cachedMenuFor:(NSString *)locationID onDate:(NSDate *)date {
    // Check last cached
    // TODO This won't fly with multiple school support
    static CDMenu *lastCached         = nil;
    static NSString *lastCachedEatery = nil;
    static NSDate *lastCachedDate     = nil;
    if (lastCached && [lastCachedEatery isEqualToString:locationID] && [lastCachedDate isEqualToDateIgnoringTime:date]) {
        return lastCached;
    }

    // Check today's cache
    if (date.isToday && todayCache[locationID]) {
        return todayCache[locationID];
    }

    // Check disk
    NSString *path = [self fullPathFor:locationID onDate:date];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        lastCached = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return lastCached;
    }

    return nil;
}

+ (void)cacheMenu:(CDMenu *)menu {
    // Compute filename and write to disk
    NSString *path = [self fullPathFor:menu.locationID onDate:menu.menuDate];
    [NSKeyedArchiver archiveRootObject:menu toFile:path];
}

- (void)searchForSchool:(NSString *)query completion:(ArrayBlock)completion {
    NSParameterAssert(query); NSParameterAssert(completion);

    [self get:^(TBURLRequestBuilder *make) {
        make.URL(@"https://campusdish.com/wcf/CampusDish.svc/BaseClientsEx");
        make.queries(@{
            @"division": @"Higher Education",
            @"dining": @"False",
            @"filter": query
        });
    } callback:^(TBResponseParser *parser) {
        NSError *error = nil;
        NSArray *schools = [MTLJSONAdapter modelsOfClass:[CDSchool class] fromJSONArray:(id)parser.JSON error:&error];
        completion(schools, parser.error ?: error);
    }];
}

- (void)setCurrentSchool:(CDSchool *)school completion:(ErrorBlock)completion {
    NSParameterAssert(school); NSParameterAssert(completion);

    _currentSchool = school;
    // Get locations, then meals
    [self fetchLocations:^(NSError *error) {
        if (!error) {
            [self fetchMeals:completion];
        } else {
            completion(error);
        }
    }];
}

- (void)fetchLocations:(ErrorBlock)completion {
    NSParameterAssert(self.currentSchool);

    [self get:^(TBURLRequestBuilder *make) {
        make.endpoint(@"/en/api/locations/GetLocations");
    } callback:^(TBResponseParser *parser) {
        //            data         document selector       model class
        ParseDocument(parser.data, toJSONArrayOfLocations, CDEatery, ^(id locations, NSError *error) {
            self.currentEateries = locations;
            completion(parser.error ?: error);
        });
    }];
}

- (void)fetchMeals:(ErrorBlock)completion {
    NSParameterAssert(self.currentEateries);
    if (!self.currentEateries.count) {
        completion(nil);
    }

    NSInteger numLocations = self.currentEateries.count;
    __block NSInteger done = 0;

    // For each location, fetch its meals and assign them.
    // When all have finished, call back without an error.
    // If there are errors, call back for each of them.
    for (CDEatery *location in self.currentEateries) {
        [self get:^(TBURLRequestBuilder *make) {
            make.endpoint(location.endpoint);
        } callback:^(TBResponseParser *parser) {
            ParseDocument(parser.data, toJSONArrayOfMeals, CDMeal, ^(id meals, NSError *error) {
                if (parser.error || error) {
                    // This location failed with an error
                    completion(parser.error ?: error);
                } else {
                    location.meals = meals;
                    done++;

                    // All locations succeeded without errors
                    // This will never be called if there is
                    // an error, but an error will trigger the
                    // completion call at least one time above
                    if (done == numLocations) {
                        completion(nil);
                    }
                }
            });
        }];
    }
}

- (void)menuFor:(CDEatery *)location onDate:(NSDate *)date completion:(MenuBlock)completion {
    NSParameterAssert(completion); NSParameterAssert(date);

    NSString *locationID = location.identifier;

    // Check cache first
    CDMenu *cached = [[self class] cachedMenuFor:locationID onDate:date];
    if (cached) {
        completion(cached, YES, nil);
        return;
    }

    NSInteger mealsToFetch = location.meals.count;
    NSMutableArray *mealPeriods = [NSMutableArray new];

    void (^loadMenus)(CDMeal *meal) = ^(CDMeal *meal) {
        [self menuFor:locationID onDate:date forMeal:meal completion:^(CDMealPeriod *period, NSError *error) {
            [mealPeriods addObject:period];

            if (mealPeriods.count == mealsToFetch) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CDMenu *menu = [CDMenu menuWithMeals:mealPeriods date:date eatery:location];
                    // Add menu to cache
                    [[self class] cacheMenu:menu];

                    // Refresh today's cache if necessary
                    if (date.isToday) {
                        [[self class] loadTodaysCache];
                    }

                    completion(menu, NO, nil); // NO -> cacheHit
                });
            }
        }];
    };

    for (CDMeal *meal in location.meals) {
        loadMenus(meal);
    }
}

/// Note: never checks cache
- (void)menuFor:(NSString *)locationID onDate:(NSDate *)date forMeal:(CDMeal *)meal completion:(MealBlock)completion {
    NSParameterAssert(locationID);

    // Data for request
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kDayYearMonth fromDate:date];
    NSNumber *day   = @(components.day);
    NSNumber *month = @(components.month);
    NSNumber *year  = @(components.year);
    NSString *dateToSend = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    NSDictionary *queryParams = @{
        @"date": dateToSend,
        @"locationId": locationID,
        @"periodId": @(meal.identifier),
        @"mode": @"Daily"
    };

    // Load and parse out a CDMealPeriod
    [self get:^(TBURLRequestBuilder *make) {
        make.endpoint(@"/en/api/menus/GetMenu");
        make.queries(queryParams);
    } callback:^(TBResponseParser *parser) {
        if (!parser.error) {
            [self parseDocument:parser.data toMeal:meal completion:^(id obj, NSError *error) {
                completion(obj, error);
            }];
        } else {
            id model = [CDMealPeriod meal:meal error:parser.error.localizedDescription];
            completion(model, nil);
        }
    }];
}

- (TBURLRequestProxy *)request:(void(^)(TBURLRequestBuilder *))configurationHandler {
    TBURLRequestProxy *proxy = [TBURLRequestBuilder make:^(TBURLRequestBuilder *make) {
        make.baseURL(self.currentSchool.baseURL);
        configurationHandler(make);
    }];

    return proxy;
}

- (void)post:(void(^)(TBURLRequestBuilder *make))configurationHandler callback:(TBResponseBlock)callback {
    [[self request:configurationHandler] POST:callback];
}

- (void)get:(void(^)(TBURLRequestBuilder *make))configurationHandler callback:(TBResponseBlock)callback {
    [[self request:configurationHandler] GET:callback];
}

- (OGDocument *)parseDocument:(NSData *)HTMLData {
    if (!HTMLData) {
        return nil;
    }

    return [ObjectiveGumbo parseDocumentWithData:HTMLData];
}

- (void)parseDocument:(NSData *)HTMLData keyPath:(SEL)keyPath class:(Class)cls completion:(ObjectBlock)completion {
    OGDocument *doc = [self parseDocument:HTMLData];
    id json = [doc performSelector:keyPath];
    NSError *error = nil;

    if ([json isKindOfClass:[NSArray class]]) {
        NSArray *models = [MTLJSONAdapter modelsOfClass:cls fromJSONArray:json error:&error];
        completion(models, error);
    } else {
        id model = [MTLJSONAdapter modelOfClass:cls fromJSONDictionary:json error:&error];
        completion(model, error);
    }
}

/// Always give you back a valid CDMealObject, populated with an error, if any
- (void)parseDocument:(NSData *)HTMLData toMeal:(CDMeal *)meal completion:(ObjectBlock)completion {
    OGDocument *doc = [self parseDocument:HTMLData];
    id json = [doc toMealPeriodJSONWithMeal:meal];

    NSError *error = nil;
    id model = [MTLJSONAdapter modelOfClass:[CDMealPeriod class] fromJSONDictionary:json error:&error];

    if (error) {
        model = [CDMealPeriod meal:meal error:error.localizedDescription];
    }

    completion(model, nil);
}

@end
