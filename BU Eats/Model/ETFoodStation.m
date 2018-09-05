//
//  ETFoodStation.m
//  BU Eats
//
//  Created by Tanner on 8/28/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "ETFoodStation.h"
#import "OGNode+Wrapper.h"

@implementation ETFoodStation

+ (instancetype)stationFromElement:(OGElement *)station {
    return [[self alloc] initWithStation:station];
}

- (id)initWithStation:(OGElement *)station {
    self = [super init];
    if (self) {
        [self buildFromStation:station];
    }
    
    return self;
}

- (void)buildFromStation:(OGElement *)station {
    NSArray<OGElement*> *items = station[@"menu__category"].firstObject[@"menu__item"];
    NSArray<OGElement*> *addons = station[@"menu__addOns"].firstObject[@"menu__item"];

    NSMutableArray *foodItems = [NSMutableArray new];
    for (OGElement *food in items) {
        [foodItems addObject:[ETFoodItem itemFromElement:food]];
    }

    _foodItems = foodItems.copy;
    _additionalItems = [ETFoodItem stringFromElements:addons];
    _name = station[@"location-headers"].firstObject.text;
}

- (NSInteger)rowCount {
    return self.foodItems.count + (self.additionalItems.length ? 1 : 0);
}

@end
