//
//  CDFoodItem.h
//  BU Eats
//
//  Created by Tanner on 9/4/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDObject.h"

@interface CDFoodItem : CDObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *calories;
@property (nonatomic, readonly) NSString *about;
@property (nonatomic, readonly) NSArray<NSString *> *allergens;

@property (nonatomic, readonly) NSString *fullInfo;

@end
