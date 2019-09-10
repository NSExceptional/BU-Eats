//
//  OGDocument+JSON.m
//  BU Eats
//
//  Created by Tanner on 9/11/18.
//Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "OGDocument+JSON.h"
#import "OGNode+Wrapper.h"
#import "OGElement+Wrapper.h"

@implementation OGDocument (JSON)

- (NSDictionary *)toMealPeriodJSONWithMeal:(CDMeal *)meal {
    if (!self.children.count) {
        return @{@"period": meal.dictionaryValue, @"error": @"Empty document"};
    }

    // Check for error first
    NSString *error = self[OGElement.rootErrorClass].firstObject.text;
    if (error) {
        return @{@"period": meal.dictionaryValue, @"error": error};
    }

    // Gather stations
    NSArray *stations = [self[OGElement.stationClass] mapped:^id(OGElement *station, NSUInteger idx) {
        NSString *title = station[OGElement.stationNameClass].firstObject.text;
        OGElement *itemContainer = station[OGElement.itemContainerClass].firstObject;
        OGElement *addonItemContainer = station[OGElement.addonItemContainerClass].firstObject;
        
        // Gather items, if any
        NSArray *items = [itemContainer[OGElement.itemClass] mapped:^id(OGElement *item, NSUInteger idx) {
            NSArray<OGElement*> *images = item[OGElement.itemAllergensClass].firstObject[GUMBO_TAG_IMG];

            // Name is usually an `a.viewItem` enclosed in a `span.item__name`
            NSString *name = item[OGElement.itemNameClass].firstObject.text;
            if (!name) {
                // If it's not, it's just text inside a `span.item__name`
                // with weird surrounding whitespace
                name = [item[OGElement.itemNameClassPlain].firstObject.text stringByTrimmingWhitespace];
                name = name ?: @"???";
            }

            // Must be mutable dictionary as calories, etc, may be nil
            NSMutableDictionary *itemDict = item.attributes.mutableCopy;
            itemDict[@"name"] = [name stringByTrimmingWhitespace];
            itemDict[@"calories"] = item[OGElement.itemCaloriesClass].firstObject.text;
            itemDict[@"about"] = item[OGElement.itemDescriptionClass].firstObject.text;

            // Could possibly remove this in favor of attributes (ie 'isvegetarian')
            itemDict[@"allergens"] = [images mapped:^id(OGElement *img, NSUInteger idx) {
                return img.attributes[@"alt"];
            }]; //[allergens componentsJoinedByString:@", "];

            return itemDict.copy;
        }];

        // Gather addon item names, if any
        NSArray *addons = [addonItemContainer[OGElement.addonItemClass] mapped:^id(OGElement *addon, NSUInteger idx) {
            return addon[OGElement.itemNameClass].firstObject.text;
        }];

        return @{@"name": title, @"foodItems": items ?: @[], @"additionalItems": addons ?: @[]};
    }];



    return @{@"period": meal.dictionaryValue, @"foodStations": stations};
}

- (NSArray *)toJSONArrayOfLocations {
    NSMutableArray *locations = [NSMutableArray new];

    for (OGElement *eatery in self[OGElement.locationClass]) {
        BOOL open = [eatery.classes containsObject:OGElement.locationClassOpen];
        NSAssert(open || [eatery.classes containsObject:OGElement.locationClassClosed], @"Not open or closed");

        NSString *identifier = eatery.attributes[OGElement.locationIDAttr];
        NSString *name = eatery[OGElement.locationNameClass][0].text;
        NSString *address = eatery[OGElement.locationAddressClass][0].text;
        NSString *times = eatery[OGElement.locationTimesClass][0].text;
        address = [address stringByTrimmingWhitespace];
        NSString *endpoint = eatery.attributes[@"href"];

        [locations addObject:@{
            @"identifier": identifier,
            @"name": name,
            @"address": address,
            @"note": times,
            @"open": @(open),
            @"endpoint": endpoint,
        }];
    }

    return locations;
}

@end
