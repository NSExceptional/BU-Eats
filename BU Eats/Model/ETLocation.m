//
//  ETLocation.m
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETLocation.h"

@implementation ETLocation

+ (instancetype)location:(Eatery)location openIntervals:(NSArray *)openIntervals {
    return [[ETLocation alloc] initWithName:NSStringFromEatery(location) andTimeOpenIntervals:openIntervals];
}

- (id)initWithName:(NSString *)name andTimeOpenIntervals:(NSArray *)openIntervals {
    NSParameterAssert(name); NSParameterAssert(openIntervals.count > 0);
    
    self = [super init];
    if (self) {
        _name = name;
        _intervalsOfOperation = openIntervals;
    }
    
    return self;
}

- (BOOL)isOpen {
    for (ETTimeInterval *interval in self.intervalsOfOperation)
        if (interval.currentTimeIsInInterval)
            return YES;
    return NO;
}

- (NSString *)status {
    if ([self.name isEqualToString:@"Memorial"])
        return @"Under rennovation until further notice";
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterNoStyle;
    
    // Open
    for (ETTimeInterval *interval in self.intervalsOfOperation)
        if (interval.currentTimeIsInInterval)
            return [NSString stringWithFormat:@"Open — Closes @\n%@", [formatter stringFromDate:interval.endTime]];
    
    // Closed - several intervals
    for (NSUInteger i = 1; i < self.intervalsOfOperation.count; i++)
        if ([ETTimeInterval between:[self.intervalsOfOperation[i-1] endTime] and:[self.intervalsOfOperation[i] startTime]].currentTimeIsInInterval) {
            if ([[self.intervalsOfOperation[i] startTime] isTomorrow])
                return [NSString stringWithFormat:@"Closed — Opens tomorrow @\n%@", [formatter stringFromDate:[self.intervalsOfOperation[i] startTime]]];
            formatter.dateStyle = NSDateFormatterShortStyle;
            [formatter setDateFormat:@"h:mm a 'on' M/dd"];
            return [NSString stringWithFormat:@"Closed — Opens @\n%@", [formatter stringFromDate:[self.intervalsOfOperation[i] startTime]]];
        }
    
    // Closed - one interval
    if ([[self.intervalsOfOperation[0] startTime] isTomorrow])
        return [NSString stringWithFormat:@"Closed — Opens tomorrow @\n%@", [formatter stringFromDate:[self.intervalsOfOperation[0] startTime]]];
    formatter.dateStyle = NSDateFormatterShortStyle;
    [formatter setDateFormat:@"h:mm a 'on' M/dd"];
    return [NSString stringWithFormat:@"Closed — Opens @\n%@", [formatter stringFromDate:[self.intervalsOfOperation[0] startTime]]];
    
    return @"null"; // Code will never execute
}

@end

@implementation ETTimeInterval (Eateries)

+ (NSArray *)hoursOfOperationForLocation:(Eatery)location {
    NSDate *today = [NSDate date];
    NSArray *penlandFriday  = @[[ETTimeInterval between:[NSDate dateTodayAtHour:7] and:[NSDate dateTodayAtHour:10]],
                                [ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:45] and:[NSDate dateTodayAtHour:3+12]],
                                [ETTimeInterval between:[[NSDate dateTodayAtHour:4+12] dateByAddingMinutes:30] and:[[NSDate dateTodayAtHour:7+12] dateByAddingMinutes:30]]];
    // Weekend times
    // - Penland:
    //    - Saturday: 10:30 - 7:00
    //    - Sunday:   10:30 - 2:00, 5:00 - 7:30
    // - Memo: (closed)
    // - EV:
    //    - Saturday: (closed)
    //    - Sunday:   5:00 - 9:00
    // - Brooks: (closed)
    if (today.isWeekend) {
        switch (location) {
            case EateryPenland:
                if (today.weekday == 1)
                    return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:30] and:[NSDate dateTodayAtHour:2+12]],
                             [ETTimeInterval between:[NSDate dateTodayAtHour:5+12] and:[[NSDate dateTodayAtHour:7+12] dateByAddingMinutes:30]]];
                return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:30] and:[NSDate dateTodayAtHour:7+12]]];
            case EateryMemorial:
//                if (today.weekday == 1)
//                    return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:1]
//                                                 and:[[NSDate dateTodayAtHour:8+12] dateByAddingDays:1]]];
//                return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:2]
//                                             and:[[NSDate dateTodayAtHour:8+12] dateByAddingDays:2]]];
                return @[[ETTimeInterval distantFuture]]; // memo is closed now
            case EateryEastVillage:
                if (today.weekday == 1)
                    return @[[ETTimeInterval between:[NSDate dateTodayAtHour:5+12] and:[NSDate dateTodayAtHour:9+12]],
                             [ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:1]
                                                 and:[[NSDate dateTodayAtHour:10] dateByAddingDays:1]]];
                return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:5+12] dateByAddingDays:1]
                                             and:[[NSDate dateTodayAtHour:9+12] dateByAddingDays:1]]];
            case EateryBrooks:
                if (today.weekday == 1)
                    return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:1]
                                                 and:[[NSDate dateTodayAtHour:10] dateByAddingDays:1]]];
                return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:2]
                                             and:[[NSDate dateTodayAtHour:10] dateByAddingDays:2]]];
        }
    }
    // Weekday times
    // - Penland:
    //    - M-F:  7 - 10, 10:45 - 3, 4:30 - 7:30
    //    - M-Th: 8 PM - 12:30 AM
    // - Memo: 7 - 8
    // - EV: 7 - 10, 10:45 - 3, 4:30 - 8:30
    // - Brooks: 7 - 10, 11 - 2, 5 - 8
    else {
        switch (location) {
            case EateryPenland:
                if (today.day != 6) // friday
                    return [penlandFriday arrayByAddingObject:[ETTimeInterval between:[NSDate dateTodayAtHour:8+12]
                                                                                  and:[[[NSDate date] dateByAddingHours:24] dateByAddingMinutes:30]]];
                return penlandFriday;
            case EateryMemorial:
                return @[[ETTimeInterval between:[NSDate dateTodayAtHour:7] and:[NSDate dateTodayAtHour:8+12]]];
            case EateryEastVillage:
                return @[[ETTimeInterval between:[NSDate dateTodayAtHour:7] and:[NSDate dateTodayAtHour:10]],
                         [ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:45] and:[NSDate dateTodayAtHour:3+12]],
                         [ETTimeInterval between:[[NSDate dateTodayAtHour:4+12] dateByAddingMinutes:30] and:[[NSDate dateTodayAtHour:8+12] dateByAddingMinutes:30]]];
            case EateryBrooks:
                return @[[ETTimeInterval between:[NSDate dateTodayAtHour:7] and:[NSDate dateTodayAtHour:10]],
                         [ETTimeInterval between:[NSDate dateTodayAtHour:11] and:[NSDate dateTodayAtHour:2+12]],
                         [ETTimeInterval between:[NSDate dateTodayAtHour:5+12] and:[NSDate dateTodayAtHour:8+12]]];
        }
    }
}

@end