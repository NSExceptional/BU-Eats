//
//  CDMenu.m
//  BU Eats
//
//  Created by Tanner on 9/15/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDMenu.h"

@implementation CDMenu

+ (instancetype)menuWithMeals:(NSArray<CDMealPeriod*> *)meals date:(NSDate *)date eatery:(CDEatery *)location {
    NSMutableDictionary *json = @{@"meals": meals,
                                  @"menuDate": date,
                                  @"location": location.name,
                                  @"locationID": location.identifier
                                  }.mutableCopy;
    json[@"shortLocation"] = [self shortNameForLocationID:location.identifier];

    return [MTLJSONAdapter modelOfClass:self fromJSONDictionary:json error:nil];
}

+ (NSString *)shortNameForLocationID:(NSString *)identifier {
    #warning TODO fill out some short names
    return nil;
}

@end
