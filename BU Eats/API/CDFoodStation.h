//
//  CDFoodStation.h
//  BU Eats
//
//  Created by Tanner on 9/4/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDObject.h"
#import "CDFoodItem.h"

@interface CDFoodStation : CDObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray<CDFoodItem*> *foodItems;
@property (nonatomic, readonly) NSString *additionalItems;

@end
