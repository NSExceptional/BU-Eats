//
//  ETFoodItem.m
//  BU Eats
//
//  Created by Tanner on 8/28/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "ETFoodItem.h"
#import "OGNode+Wrapper.h"

@implementation ETFoodItem

+ (instancetype)itemFromElement:(OGElement *)item {
    return [[self alloc] initWithItem:item];
}

+ (NSString *)stringFromElements:(NSArray<OGElement*> *)items {
    if (!items.count) {
        return nil;
    }
    
    NSMutableString *str = [NSMutableString string];
    for (OGElement *item in items) {
        NSString *name = item[@"viewItem"].firstObject.text;
        [str appendFormat:@"%@, ", name];
    }

    [str deleteCharactersInRange:NSMakeRange(str.length-2, 2)];
    return str.copy;
}

- (id)initWithItem:(OGElement *)item {
    self = [super init];
    if (self) {
        [self buildFromItem:item];
    }
    
    return self;
}

- (void)buildFromItem:(OGElement *)item {
    _name = item[@"viewItem"].firstObject.text;
    _calories = item[@"item__calories"].firstObject.text;
    _about = item[@"item__content"].firstObject.text;

    NSArray<OGElement*> *images = item[@"item__allergens"].firstObject[GUMBO_TAG_IMG];
    NSMutableArray *allergens = [NSMutableArray new];
    for (OGElement *img in images) {
        [allergens addObject:img.attributes[@"alt"]];
    }

    _allergens = [allergens componentsJoinedByString:@", "];

    _fullInfo = [NSString stringWithFormat:@"%@\n%@\n\n%@", self.calories, self.allergens, self.about];
}

@end
