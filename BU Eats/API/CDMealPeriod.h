//
//  CDMealPeriod.h
//  BU Eats
//
//  Created by Tanner on 9/15/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDObject.h"
#import "CDMeal.h"
#import "CDFoodStation.h"

@interface CDMealPeriod : CDObject

+ (instancetype)meal:(CDMeal *)meal error:(NSString *)error;

@property (nonatomic, readonly) CDMeal *period;
@property (nonatomic, readonly) NSArray<CDFoodStation *> *foodStations;
@property (nonatomic, readonly) NSString *error;

+ (UIImage *)iconForMeal:(CDMeal *)meal;

@end
