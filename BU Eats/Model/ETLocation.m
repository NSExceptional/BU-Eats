//
//  ETLocation.m
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETLocation.h"

#define kDaySunday 1
#define kDayFriday 6
#define kDaySaturday 7

@implementation ETLocation

+ (instancetype)location:(Eatery)location openIntervals:(NSDictionary *)openIntervals message:(NSString *)message {
    return [[ETLocation alloc] initWithName:NSStringFromEatery(location) andTimeOpenIntervals:openIntervals message:message];
}

- (id)initWithName:(NSString *)name andTimeOpenIntervals:(NSDictionary *)openIntervals message:(NSString *)message {
    NSParameterAssert(name); NSParameterAssert(message || openIntervals.count > 0);
    
    self = [super init];
    if (self) {
        _name = name;
        _message = message;
        _intervalsOfOperation = openIntervals ?: @{};
    }
    
    return self;
}

- (BOOL)isOpen {
    return YES;
    // TODO: fix me
    //    for (ETTimeInterval *interval in self.todaysIntervalsOfOperation)
    //        if (interval.currentTimeIsInInterval)
    //            return YES;
    //    return NO;
}

- (NSArray *)todaysIntervalsOfOperation {
    NSDate *today = [NSDate date];
    
    if (today.day == kDayFriday   && self.intervalsOfOperation[kHOOPFriday])
        return self.intervalsOfOperation[kHOOPFriday];
    if (today.day == kDaySaturday && self.intervalsOfOperation[kHOOPSaturday])
        return self.intervalsOfOperation[kHOOPSaturday];
    if (today.day == kDaySunday   && self.intervalsOfOperation[kHOOPSunday])
        return self.intervalsOfOperation[kHOOPSunday];
    
    if (!today.isWeekend)
        return self.intervalsOfOperation[kHOOPWeekday] ?: @[];
    
    return @[];
}

//- (NSString *)status {
//    if (self.message)
//        return self.message;
//    
////    if ([self.name isEqualToString:@"Memorial"])
////        return @"Under rennovation until further notice";
//    NSDateFormatter *formatter = [NSDateFormatter new];
//    formatter.timeStyle = NSDateFormatterShortStyle;
//    formatter.dateStyle = NSDateFormatterNoStyle;
//    
//    // Open
//    for (ETTimeInterval *interval in self.todaysIntervalsOfOperation)
//        if (interval.currentTimeIsInInterval)
//            return [NSString stringWithFormat:@"Open — Closes @\n%@", [formatter stringFromDate:interval.endTime]];
//    
//    // Closed - several intervals
//    for (NSUInteger i = 1; i < self.todaysIntervalsOfOperation.count; i++)
//        // Checks to see if we're closed but in between two meals
//        if ([ETTimeInterval between:[self.todaysIntervalsOfOperation[i-1] endTime] and:[self.todaysIntervalsOfOperation[i] startTime]].currentTimeIsInInterval) {
//            if ([[self.todaysIntervalsOfOperation[i] startTime] isTomorrow])
//                return [NSString stringWithFormat:@"Closed — Opens tomorrow @\n%@", [formatter stringFromDate:[self.todaysIntervalsOfOperation[i] startTime]]];
//            formatter.dateStyle = NSDateFormatterShortStyle;
//            [formatter setDateFormat:@"h:mm a 'on' M/dd"];
//            return [NSString stringWithFormat:@"Closed — Opens @\n%@", [formatter stringFromDate:[self.todaysIntervalsOfOperation[i] startTime]]];
//        }
//    
//    // Closed - one interval
//    if ([[self.todaysIntervalsOfOperation[0] startTime] isTomorrow])
//        return [NSString stringWithFormat:@"Closed — Opens tomorrow @\n%@", [formatter stringFromDate:[self.todaysIntervalsOfOperation[0] startTime]]];
//    formatter.dateStyle = NSDateFormatterShortStyle;
//    [formatter setDateFormat:@"h:mm a 'on' M/dd"];
//    return [NSString stringWithFormat:@"Closed — Opens @\n%@", [formatter stringFromDate:[self.todaysIntervalsOfOperation[0] startTime]]];
//    
//    return @"null"; // Code will never execute
//}

@end

@implementation ETTimeInterval (Eateries)

+ (NSArray *)hoursOfOperationPropertyListValueForLocation:(Eatery)location {
    // TODO: fix me
    return @[];
    //    return [[self hoursOfOperationForLocation:location] valueForKeyPath:@"@unionOfObjects.propertyListValue"];
}

+ (NSDictionary *)allLocationsHoursOfOperationPropertyListValue {
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    for (Eatery e = EateryPenland; e <= kEateryCount; e++)
        values[NSStringFromEatery(e)] = [self hoursOfOperationPropertyListValueForLocation:e];
    return values;
}

//+ (NSDictionary *)hoursOfOperationForLocation:(Eatery)location {
//    NSDate *today = [NSDate date];
//    // Weekend times
//    // - Penland:
//    //    - Saturday: 10:30 - 7:00
//    //    - Sunday:   10:30 - 2:00, 5:00 - 7:30
//    // - Memo: (closed)
//    // - EV:
//    //    - Saturday: (closed)
//    //    - Sunday:   5:00 - 9:00
//    // - Brooks: (closed)
//    
//    switch (location) {
//        case EateryPenland: {
//            return @{kHOOPWeekday:  @[[ETTimeInterval between:[NSDate dateTodayAtHour:7] and:[NSDate dateTodayAtHour:10]],
//                                      [ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:45] and:[NSDate dateTodayAtHour:3+12]],
//                                      [ETTimeInterval between:[[NSDate dateTodayAtHour:4+12] dateByAddingMinutes:30] and:[[NSDate dateTodayAtHour:7+12] dateByAddingMinutes:30]],
//                                      [ETTimeInterval between:[NSDate dateTodayAtHour:8+12] and:[[[NSDate date] dateByAddingHours:24] dateByAddingMinutes:30]]],
//                     kHOOPFriday:   @[[ETTimeInterval between:[NSDate dateTodayAtHour:7] and:[NSDate dateTodayAtHour:10]],
//                                      [ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:45] and:[NSDate dateTodayAtHour:3+12]],
//                                      [ETTimeInterval between:[[NSDate dateTodayAtHour:4+12] dateByAddingMinutes:30] and:[[NSDate dateTodayAtHour:7+12] dateByAddingMinutes:30]]],
//                     kHOOPSaturday: @[[ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:30] and:[NSDate dateTodayAtHour:7+12]]],
//                     kHOOPSunday:   @[[ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:30] and:[NSDate dateTodayAtHour:2+12]],
//                                      [ETTimeInterval between:[NSDate dateTodayAtHour:5+12] and:[[NSDate dateTodayAtHour:7+12] dateByAddingMinutes:30]]]}
//        }
//        case EateryMemorial: {
//            return @{kHOOPWeekday: @[[ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:1]
//                                                         and:[[NSDate dateTodayAtHour:8+12] dateByAddingDays:1]]],
//                     kho}
//            return @{kHOOPWeekday: @[]};
//        }
//        case EateryEastVillage: {
//            return @{kHOOPWeekday: nil}
//        }
//        case EateryBrooks: {
//            return @{kHOOPWeekday: nil}
//        }
//    }
//    
//    if (today.isWeekend) {
//        switch (location) {
//            case EateryPenland:
//                if (today.weekday == kDaySunday)
//                    return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:30] and:[NSDate dateTodayAtHour:2+12]],
//                             [ETTimeInterval between:[NSDate dateTodayAtHour:5+12] and:[[NSDate dateTodayAtHour:7+12] dateByAddingMinutes:30]]];
//                return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:30] and:[NSDate dateTodayAtHour:7+12]]];
//            case EateryMemorial:
//                if (today.weekday == 1)
//                    return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:1]
//                                                 and:[[NSDate dateTodayAtHour:8+12] dateByAddingDays:1]]];
//                return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:2]
//                                             and:[[NSDate dateTodayAtHour:8+12] dateByAddingDays:2]]];
//                return @[[ETTimeInterval distantFuture]]; // memo is closed now
//            case EateryEastVillage:
//                if (today.weekday == kDaySunday)
//                    return @[[ETTimeInterval between:[NSDate dateTodayAtHour:5+12] and:[NSDate dateTodayAtHour:9+12]],
//                             [ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:1]
//                                                 and:[[NSDate dateTodayAtHour:10] dateByAddingDays:1]]];
//                return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:5+12] dateByAddingDays:1]
//                                             and:[[NSDate dateTodayAtHour:9+12] dateByAddingDays:1]]];
//            case EateryBrooks:
//                if (today.weekday == kDaySunday)
//                    return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:1]
//                                                 and:[[NSDate dateTodayAtHour:10] dateByAddingDays:1]]];
//                return @[[ETTimeInterval between:[[NSDate dateTodayAtHour:7] dateByAddingDays:2]
//                                             and:[[NSDate dateTodayAtHour:10] dateByAddingDays:2]]];
//        }
//    }
//    // Weekday times
//    // - Penland:
//    //    - M-F:  7 - 10, 10:45 - 3, 4:30 - 7:30
//    //    - M-Th: 8 PM - 12:30 AM
//    // - Memo: 7 - 8
//    // - EV: 7 - 10, 10:45 - 3, 4:30 - 8:30
//    // - Brooks: 7 - 10, 11 - 2, 5 - 8
//    else {
//        switch (location) {
//            case EateryPenland:
//                if (today.day != kDayFriday) // friday
//                    return [penlandFriday arrayByAddingObject:[ETTimeInterval between:[NSDate dateTodayAtHour:8+12]
//                                                                                  and:[[[NSDate date] dateByAddingHours:24] dateByAddingMinutes:30]]];
//                return penlandFriday;
//            case EateryMemorial:
//                return @[[ETTimeInterval between:[NSDate dateTodayAtHour:7] and:[NSDate dateTodayAtHour:8+12]]];
//            case EateryEastVillage:
//                return @[[ETTimeInterval between:[NSDate dateTodayAtHour:7] and:[NSDate dateTodayAtHour:10]],
//                         [ETTimeInterval between:[[NSDate dateTodayAtHour:10] dateByAddingMinutes:45] and:[NSDate dateTodayAtHour:3+12]],
//                         [ETTimeInterval between:[[NSDate dateTodayAtHour:4+12] dateByAddingMinutes:30] and:[[NSDate dateTodayAtHour:8+12] dateByAddingMinutes:30]]];
//            case EateryBrooks:
//                return @[[ETTimeInterval between:[NSDate dateTodayAtHour:7] and:[NSDate dateTodayAtHour:10]],
//                         [ETTimeInterval between:[NSDate dateTodayAtHour:11] and:[NSDate dateTodayAtHour:2+12]],
//                         [ETTimeInterval between:[NSDate dateTodayAtHour:5+12] and:[NSDate dateTodayAtHour:8+12]]];
//        }
//    }
//}

@end