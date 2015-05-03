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

+ (instancetype)location:(Eatery)location openIntervals:(NSArray *)openIntervals;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray  *intervalsOfOperation;

- (BOOL)isOpen;
- (NSString *)status;

@end


@interface ETTimeInterval (Eateries)
+ (NSArray *)hoursOfOperationForLocation:(Eatery)location;
@end