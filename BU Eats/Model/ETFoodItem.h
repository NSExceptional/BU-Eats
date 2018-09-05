//
//  ETFoodItem.h
//  BU Eats
//
//  Created by Tanner on 8/28/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OGElement;

@interface ETFoodItem : NSObject

+ (instancetype)itemFromElement:(OGElement *)item;
+ (NSString *)stringFromElements:(NSArray<OGElement*> *)items;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *calories;
@property (nonatomic, readonly) NSString *allergens;
@property (nonatomic, readonly) NSString *about;

@property (nonatomic, readonly) NSString *fullInfo;

@end
