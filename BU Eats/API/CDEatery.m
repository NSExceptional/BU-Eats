//
//  CDEatery.m
//  BU Eats
//
//  Created by Tanner on 9/15/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDEatery.h"

#import "ETLocation.h"
#import "BUDiningMenu.h"
#import "CDMeal.h"

@implementation CDEatery

+ (NSArray<CDEatery *> *)baylorEateries {
    NSArray *meals = CDMeal.baylorMeals;

    return [ETEateries() mapped:^id(ETLocation *location, NSUInteger idx) {
        return [self fromJSON:@{
            @"name": location.name,
            @"hours": location.message, // fullHours doesn't appear to be used
            @"identifier": @(location.identifier).stringValue,
            @"meals": meals
        }];
//        CDEatery *eatery = [CDEatery new];
//        eatery->_name = location.name;
//        eatery->_hours = location.fullHours;
//        eatery->_identifier = @(location.identifier).stringValue;
//        eatery->_meals = meals;
//        return eatery;
    }];
}

@end
