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

+ (instancetype)location:(BaylorEatery)location;
+ (instancetype)location:(BaylorEatery)location openIntervals:(NSArray *)openIntervals;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSString *fullHours;
@property (nonatomic, readonly) BaylorEatery identifier;

@end
