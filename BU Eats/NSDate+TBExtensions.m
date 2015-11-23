//
//  NSDate+TBExtensions.m
//  BU Eats
//
//  Created by Tanner on 8/22/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "NSDate+TBExtensions.h"

#define DATE_COMPONENTS (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (TBExtensions)

- (NSDate *)dateAtStartOfWeek {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour   = 0;
    components.minute = 0;
    components.second = 0;
    components.day    = components.day - components.weekday + 1;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

//- (NSDate *)dateIgnoringMonth {
//    
//}
//
//- (NSDate *)dateIgnoringYear {
//    
//}

@end
