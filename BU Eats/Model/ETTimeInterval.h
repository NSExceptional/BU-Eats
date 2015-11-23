//
//  ETTimeInterval.h
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    NSUInteger hour;
    NSUInteger minutes;
} ETTimeOffset;

/** Costructs an NSDate object offset from the start of the week by the given hour and minute. */
extern NSDate * ETDateFromTimeOffset(ETTimeOffset offset, NSUInteger weekday);
/** Constructs the offset of the given date relative to the start of the current week. */
extern ETTimeOffset ETTimeOffsetGet(NSDate *date);
/** Constructs an offset given a specific hour and number of minutes. */
extern ETTimeOffset ETTimeOffsetMake(NSUInteger hour, NSUInteger minutes);

@interface ETTimeInterval : NSObject

+ (instancetype)timeIntervalFromPropertyListValue:(NSDictionary *)value;
+ (instancetype)between:(ETTimeOffset)start and:(ETTimeOffset)end weekday:(NSUInteger)weekday;
+ (instancetype)absoluteBetween:(NSDate *)start and:(NSDate *)end;

+ (NSArray *)between:(ETTimeOffset)start and:(ETTimeOffset)end onDays:(NSIndexSet *)days;

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