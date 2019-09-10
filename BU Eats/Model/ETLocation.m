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

+ (instancetype)location:(BaylorEatery)location {
    return [self location:location openIntervals:nil];
}

+ (instancetype)location:(BaylorEatery)location openIntervals:(NSArray *)openIntervals {
    NSString *name = ETStringFromEatery(location);
    NSString *message = ETMessageForEatery(location);
    NSString *hours = ETHoursForEatery(location);
    return [[ETLocation alloc] initWithName:name timeOpenIntervals:openIntervals message:message hours:hours identifier:location];
}

- (id)initWithName:(NSString *)name
 timeOpenIntervals:(NSArray *)openIntervals
           message:(NSString *)message
             hours:(NSString *)hours
        identifier:(BaylorEatery)identifier {
    NSParameterAssert(name); NSParameterAssert(message || openIntervals.count > 0);
    NSParameterAssert(openIntervals == nil); // Needs work, types don't match up
    
    self = [super init];
    if (self) {
        _name = name;
        _message = message;
        _fullHours = hours;
        _identifier = identifier;
    }
    
    return self;
}

@end
