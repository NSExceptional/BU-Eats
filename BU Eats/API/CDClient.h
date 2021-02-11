//
//  CDClient.h
//  BU Eats
//
//  Created by Tanner on 9/4/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDEatery.h"
#import "CDSchool.h"
@class CDMealPeriod, CDMenu, CDMeal;

typedef void (^MealBlock)(CDMealPeriod *meal, NSError *error);
typedef void (^MenuBlock)(CDMenu *menu, BOOL cacheHit, NSError *error);
typedef void (^ObjectBlock)(id obj, NSError *error);
typedef void (^ArrayBlock)(NSArray *response, NSError *error);
typedef void (^DictionaryBlock)(NSDictionary *response, NSError *error);
typedef void (^ErrorBlock)(NSError *error);
typedef void (^MessageBlock)(NSString *message);

/// An API client for Campus Dish.
@interface CDClient : NSObject

@property (nonatomic, readonly, class) CDClient *sharedClient;

@property (nonatomic) CDSchool *currentSchool;
@property (nonatomic) NSArray<CDEatery *> *currentEateries;

/// @arg completion takes an array of CDSchool objects
- (void)searchForSchool:(NSString *)query completion:(ArrayBlock)completion;
/// Populates currentSchool and currentEateries
/// @param completion May be called more than once if there are multiple errors
- (void)setCurrentSchool:(CDSchool *)location completion:(ErrorBlock)completion;
- (void)menuFor:(CDEatery *)location onDate:(NSDate *)date completion:(MenuBlock)completion;

/// Update OGElement.keyPathMapping if possible
- (void)checkForSchemaUpdates:(ErrorBlock)completion;

@end
