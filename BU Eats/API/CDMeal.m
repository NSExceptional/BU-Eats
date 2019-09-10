//
//  CDMeal.m
//  BU Eats
//
//  Created by Tanner Bennett on 9/10/19.
//  Copyright © 2019 Tanner Bennett. All rights reserved.
//

#import "CDMeal.h"
#import "BUDiningMenu.h"

@implementation CDMeal

+ (NSArray<CDMeal *> *)baylorMeals {
    NSArray<NSNumber *> *meals = @[@(MealBreakfast), @(MealLunch), @(MealDinner)];
    return [meals mapped:^id(NSNumber *m, NSUInteger idx) {
        return [CDMeal fromJSON:@{
            @"identifier": m,
            @"name": [self titleForBaylorMeal:m.integerValue]
        }];
    }];
}

+ (NSString *)titleForBaylorMeal:(Meal)meal {
    switch (meal) {
        case MealBreakfast: return @"Breakfast";
        case MealLunch:     return @"Lunch";
        case MealDinner:    return @"Dinner";
    }

    return nil;
}

@end
