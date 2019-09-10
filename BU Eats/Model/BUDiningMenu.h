//
//  BUDiningMenu.h
//  Gumbo
//
//  Created by Justin Paul on 4/25/15.
//  Copyright (c) 2015 WireIron. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETLocation;

extern NSUInteger const kEateryCount;
typedef NSUInteger Eatery;
typedef NS_ENUM(NSUInteger, BaylorEatery)
{
    EateryPenland = 1047,
    EateryMemorial = 1045,
    EateryEastVillage = 6524,
    EateryBrooks = 6523
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
