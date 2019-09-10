//
//  CDMealPeriod.m
//  BU Eats
//
//  Created by Tanner on 9/15/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDMealPeriod.h"

@implementation CDMealPeriod

+ (instancetype)meal:(CDMeal *)meal error:(NSString *)errorString {
    NSError *error = nil;
    NSDictionary *json = @{@"period": meal.dictionaryValue, @"error": errorString};
    CDMealPeriod *model = [MTLJSONAdapter modelOfClass:[CDMealPeriod class] fromJSONDictionary:json error:&error];
    NSAssert(model && !error, @"CDMealPeriod should always be valid with an error");

    return model;
}

+ (NSValueTransformer *)foodStationsJSONTransformer {
    return [self JSONModelArrayTransformerForClass:[CDFoodStation class]];
}

+ (UIImage *)iconForMeal:(CDMeal *)meal {
    NSString *name = nil;

    for (NSString *mealName in @[@"Breakfast", @"Lunch", @"Dinner"]) {
        if ([meal.name localizedCaseInsensitiveContainsString:mealName]) {
            name = mealName;
            break;
        }
    }

    return [UIImage imageNamed:name];
}

@end
