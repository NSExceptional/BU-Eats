//
//  ETTimeInterval.m
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETTimeInterval.h"

NSDate * ETDateFromTimeOffset(ETTimeOffset offset, NSUInteger weekday) {
    return [[[[[NSDate date] dateAtStartOfWeek] dateByAddingDays:weekday-1] dateByAddingHours:offset.hour] dateByAddingMinutes:offset.minutes];
}

ETTimeOffset ETTimeOffsetGet(NSDate *date) {
    ETTimeOffset offset;
    offset.hour    = date.hour;
    offset.minutes = date.minute;
    return offset;
}

ETTimeOffset ETTimeOffsetMake(NSUInteger hour, NSUInteger minutes) {
    ETTimeOffset offset;
    offset.hour    = hour;
    offset.minutes = minutes;
    return offset;
}

@interface ETTimeInterval ()
@property (nonatomic, readonly) BOOL absolute;
@end

@implementation ETTimeInterval

+ (instancetype)timeIntervalFromPropertyListValue:(NSDictionary *)value {
    return [[self alloc] initWithStartTime:value[@"start"] andEndTime:value[@"end"] absolute:[value[@"absolute"] boolValue]];
}

+ (NSArray *)between:(ETTimeOffset)start and:(ETTimeOffset)end onDays:(NSIndexSet *)days {
    NSMutableArray *intervals = [NSMutableArray array];
    [days enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < 1 || idx > 7) return;
        
        [intervals addObject:[ETTimeInterval between:start and:end weekday:idx]];
    }];
    
    return intervals.copy;
}

+ (instancetype)between:(ETTimeOffset)start and:(ETTimeOffset)end weekday:(NSUInteger)weekday {
    NSDate *startDate = ETDateFromTimeOffset(start, weekday);
    NSDate *endDate   = ETDateFromTimeOffset(end, weekday);
    return [[self alloc] initWithStartTime:startDate andEndTime:endDate absolute:NO];
}

+ (instancetype)absoluteBetween:(NSDate *)start and:(NSDate *)end {
    return [[self alloc] initWithStartTime:start andEndTime:end absolute:YES];
}

- (id)initWithStartTime:(NSDate *)start andEndTime:(NSDate *)end absolute:(BOOL)absolute {
    NSParameterAssert([start isKindOfClass:NSDate.class]); NSParameterAssert([end isKindOfClass:NSDate.class]);
    
    self = [super init];
    if (self) {
        _startTime = start;
        _endTime   = end;
        _absolute  = absolute;
        _propertyListValue = @{@"start": self.startTime, @"end": self.endTime, @"absolute": @(self.absolute)};
    }
    
    return self;
}

- (BOOL)currentTimeIsInInterval {
    NSDate *now = [NSDate date];
    return [now compare:self.startTime] == NSOrderedDescending
    && [now compare:self.endTime] == NSOrderedAscending;
}

@end


#pragma mark NSDate category

@implementation NSDate (hour)

+ (NSDate *)dateTodayAtHour:(NSUInteger)militaryHour
{
    militaryHour = militaryHour % 24;
    
    NSDate *newDate = [[NSDate date] dateAtStartOfDay];
    return [newDate dateByAddingHours:militaryHour];
}

+ (NSArray *)daysForTheNextMonth {
    NSDate *today = [[[NSDate date] dateAtStartOfDay] dateByAddingHours:12];
    
    NSMutableArray *dates = [NSMutableArray new];
    for (NSInteger i = 0; i < 32; i++)
        [dates addObject:[today dateByAddingDays:i]];
    
    return dates.copy;
}

- (BOOL)isWeekend {
    return self.weekday == 1 || self.weekday == 7;
}

@end