//
//  CDSchool.h
//  BU Eats
//
//  Created by Tanner on 9/15/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDObject.h"

typedef NS_ENUM(NSUInteger, BUCDMeal)
{
    CDMealBreakfast = 1117,
    CDMealLunch,
    CDMealDinner
};

@interface CDSchool : CDObject

+ (instancetype)baylor;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *baseURL;

@end
