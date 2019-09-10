//
//  OGElement+Wrapper.h
//  BU Eats
//
//  Created by Tanner on 9/6/18.
//Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "OGElement.h"

@interface OGElement (Wrapper)

/// Maps HTML classes to all other properties in this category
@property (nonatomic, class) NSDictionary *keyPathMapping;

@property (nonatomic, class) NSString *rootErrorClass;
@property (nonatomic, class) NSString *stationClass;
@property (nonatomic, class) NSString *stationNameClass;
@property (nonatomic, class) NSString *itemClass;
@property (nonatomic, class) NSString *addonItemClass;
@property (nonatomic, class) NSString *itemContainerClass;
@property (nonatomic, class) NSString *addonItemContainerClass;

@property (nonatomic, class) NSString *itemNameClass;
@property (nonatomic, class) NSString *itemNameClassPlain;
@property (nonatomic, class) NSString *itemCaloriesClass;
@property (nonatomic, class) NSString *itemAllergensClass;
@property (nonatomic, class) NSString *itemDescriptionClass;
@property (nonatomic, class) NSString *addonItemNameClass;

@property (nonatomic, class) NSString *locationClass;
@property (nonatomic, class) NSString *locationClassOpen;
@property (nonatomic, class) NSString *locationClassClosed;
@property (nonatomic, class) NSString *locationNameClass;
@property (nonatomic, class) NSString *locationAddressClass;
@property (nonatomic, class) NSString *locationTimesClass;

@property (nonatomic, class) NSString *locationIDAttr;

@end
