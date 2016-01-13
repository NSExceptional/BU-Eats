//
//  ETLocation.h
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETTimeInterval.h"
#import "BUDiningMenu.h"


@interface ETLocation : NSObject

+ (instancetype)location:(Eatery)location openIntervals:(NSArray *)openIntervals message:(NSString *)message;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSDictionary *intervalsOfOperation;
@property (nonatomic, readonly) NSArray *todaysIntervalsOfOperation;

- (BOOL)isOpen;
//- (NSString *)status;

@end


@interface ETTimeInterval (Eateries)
+ (NSDictionary *)allLocationsHoursOfOperationPropertyListValue;
//+ (NSDictionary *)hoursOfOperationForLocation:(Eatery)location;
@end