//
//  OGElement+Wrapper.m
//  BU Eats
//
//  Created by Tanner on 9/6/18.
//Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "OGElement+Wrapper.h"
#import "OGNode+Wrapper.h"

#define StaticPropertyIMP(type, name, setter, value) static type _##name = @"##value##"; \
+ (type)name { \
    return _##name; \
} \
+ (void) setter:(type)arg { \
    _##name = arg; \
}

@implementation OGElement (Wrapper)

static NSDictionary *_keyPathMapping;
+ (NSDictionary *)keyPathMapping {
    return _keyPathMapping ?: @{};
}

+ (void)setKeyPathMapping:(NSDictionary *)mapping {
    _keyPathMapping = mapping;
    [mapping enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [self setValue:value forKey:key];
    }];
}

StaticPropertyIMP(NSString *, rootErrorClass, setRootErrorClass, text-center)
StaticPropertyIMP(NSString *, stationClass, setStationClass, menu__station)
StaticPropertyIMP(NSString *, stationNameClass, setStationNameClass, location-headers)
StaticPropertyIMP(NSString *, itemClass, setItemClass, menu__item)
StaticPropertyIMP(NSString *, addonItemClass, setAddonItemClass, menu__item)
StaticPropertyIMP(NSString *, itemContainerClass, setItemContainerClass, menu__category)
StaticPropertyIMP(NSString *, addonItemContainerClass, setAddonItemContainerClass, menu__addOns)

StaticPropertyIMP(NSString *, itemNameClass, setItemNameClass, viewItem)
StaticPropertyIMP(NSString *, itemCaloriesClass, setItemCaloriesClass, item__calories)
StaticPropertyIMP(NSString *, itemAllergensClass, setItemAllergensClass, item__allergens)
StaticPropertyIMP(NSString *, itemDescriptionClass, setItemDescriptionClass, item__content)
StaticPropertyIMP(NSString *, addonItemNameClass, setAddonItemNameClass, viewItem)

@end
