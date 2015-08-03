//
//  ETTimeInterval.h
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETTimeInterval : NSObject

+ (instancetype)timeIntervalFromPropertyListValue:(NSDictionary *)value;
+ (instancetype)between:(NSDate *)start and:(NSDate *)end;
+ (instancetype)distantPast;
+ (instancetype)distantFuture;
+ (instancetype)allTime;

- (BOOL)currentTimeIsInInterval;

@property (nonatomic, readonly) NSDate *startTime;
@property (nonatomic, readonly) NSDate *endTime;
@property (nonatomic, readonly) NSDictionary *propertyListValue;

@end

#pragma mark NSDate category

@interface NSDate (hour)
+ (NSDate *)dateTodayAtHour:(NSUInteger)militaryHour;
+ (NSArray *)daysForTheNextMonth;
- (BOOL)isWeekend;
@end