//
//  BUDiningMenu.h
//  Gumbo
//
//  Created by Justin Paul on 4/25/15.
//  Copyright (c) 2015 WireIron. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETLocation;

/** FullMenuBlock takes a dictionary, where the keys for failed requests are NSErrors. */
typedef void (^FullMenuBlock)(NSDictionary *fullMenu, BOOL cacheHit);
typedef void (^MenuBlock)(NSError *error, NSDictionary *menu);

extern NSUInteger const kEateryCount;
typedef NS_ENUM(NSUInteger, Eatery)
{
    EateryPenland = 1,
    EateryMemorial,
    EateryEastVillage,
    EateryBrooks
};

extern NSArray<ETLocation*> * ETEateries(void);

extern NSString * ETStringFromEatery(Eatery e);
extern NSString * ETMessageForEatery(Eatery e);
extern NSString * ETHoursForEatery(Eatery e);

typedef NS_ENUM(NSUInteger, Meal)
{
    MealBreakfast = 1117,
    MealLunch,
    MealDinner
};

extern NSString * NSStringFromMeal(Meal m);
extern Meal MealFromNSString(NSString *m);

@interface BUDiningMenu : NSObject

+ (void)menuFor:(Eatery)location onDate:(NSDate *)date completion:(FullMenuBlock)completion;
//+ (void)menuFor:(Eatery)location onDate:(NSDate *)date forMeal:(Meal)meal completion:(MenuBlock)completion;

@end