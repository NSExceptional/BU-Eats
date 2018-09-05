//
//  ETFoodStation.h
//  BU Eats
//
//  Created by Tanner on 8/28/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETFoodItem.h"
@class OGElement;

@interface ETFoodStation : NSObject

+ (instancetype)stationFromElement:(OGElement *)station;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray<ETFoodItem*> *foodItems;
@property (nonatomic, readonly) NSString *additionalItems;

@property (nonatomic, readonly) NSInteger rowCount;

@end
