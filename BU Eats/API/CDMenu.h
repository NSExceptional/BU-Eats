//
//  CDMenu.h
//  BU Eats
//
//  Created by Tanner on 9/15/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDEatery.h"
#import "CDMealPeriod.h"

@interface CDMenu : CDObject

+ (instancetype)menuWithMeals:(NSArray<CDMealPeriod*> *)meals date:(NSDate *)date eatery:(CDEatery *)location;

@property (nonatomic, readonly) NSString *location;
@property (nonatomic, readonly) NSString *shortLocation;
@property (nonatomic, readonly) NSString *locationID;
@property (nonatomic, readonly) NSDate *menuDate;
@property (nonatomic, readonly) NSArray<CDMealPeriod *> *meals;

@end
