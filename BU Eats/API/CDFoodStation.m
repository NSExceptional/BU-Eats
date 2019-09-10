//
//  CDFoodStation.m
//  BU Eats
//
//  Created by Tanner on 9/4/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDFoodStation.h"

@implementation CDFoodStation

- (void)postInit {
    if (!self.foodItems.count && !self.additionalItems.length) {
        _name = [_name stringByAppendingString:@" (empty)"];
    }
}

+ (NSValueTransformer *)foodItemsJSONTransformer {
    return [self JSONModelArrayTransformerForClass:[CDFoodItem class]];
}

+ (NSValueTransformer *)additionalItemsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *addons, BOOL *success, NSError **error) {
        return [addons componentsJoinedByString:@", "];
    } reverseBlock:^id(NSString *addons, BOOL *success, NSError **error) {
        return [addons componentsSeparatedByString:@", "];
    }];
}

@end
