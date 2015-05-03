//
//  ETTimeInterval.m
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETTimeInterval.h"

@implementation ETTimeInterval

+ (instancetype)between:(NSDate *)start and:(NSDate *)end {
    return [[ETTimeInterval alloc] initWithStartTime:start andEndTime:end];
}

+ (instancetype)distantPast {
    return [ETTimeInterval between:[NSDate distantPast] and:[[NSDate distantPast] dateByAddingMinutes:1]];
}

+ (instancetype)distantFuture {
    return [ETTimeInterval between:[[NSDate distantFuture] dateBySubtractingMinutes:1] and:[NSDate distantFuture]];
}

+ (instancetype)allTime {
    return [ETTimeInterval between:[NSDate distantPast] and:[NSDate distantFuture]];
}

- (id)initWithStartTime:(NSDate *)start andEndTime:(NSDate *)end {
    NSParameterAssert([start isKindOfClass:NSDate.class]); NSParameterAssert([end isKindOfClass:NSDate.class]);
    
    self = [super init];
    if (self) {
        _startTime = start;
        _endTime   = end;
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