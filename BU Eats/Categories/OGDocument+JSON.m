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

- (NSDictionary *)toJSON {
    if (!self.children.count) {
        return @{@"error": @"Empty document"};
    }

    NSMutableDictionary *json = [NSMutableDictionary new];

    // Check for error first
    NSString *error = self[OGElement.rootErrorClass].firstObject.text;
    if (error) {
        json[@"error"] = error;
        return json;
    }

    // Gather stations
    NSMutableArray *stations = [NSMutableArray new];
    for (OGElement *station in self[OGElement.stationClass]) {
        NSMutableArray *items = [NSMutableArray new];
        NSMutableArray *addons = [NSMutableArray new];
        NSString *title = station[OGElement.stationNameClass].firstObject.text;

        // Gather items
        OGElement *container = station[OGElement.itemContainerClass].firstObject;
        for (OGElement *item in container[OGElement.itemClass]) {
            NSMutableDictionary *itemDict = item.attributes.mutableCopy;
            itemDict[@"name"] = item[OGElement.itemNameClass].firstObject.text;
            itemDict[@"calories"] = item[OGElement.itemCaloriesClass].firstObject.text;
            itemDict[@"about"] = item[OGElement.itemDescriptionClass].firstObject.text;

            // Could possibly remove this in favor of attributes (ie 'isvegetarian')
            NSArray<OGElement*> *images = item[OGElement.itemAllergensClass].firstObject[GUMBO_TAG_IMG];
            NSMutableArray *allergens = [NSMutableArray new];
            for (OGElement *img in images) {
                [allergens addObject:img.attributes[@"alt"]];
            }
            itemDict[@"allergens"] = allergens;//[allergens componentsJoinedByString:@", "];

            [items addObject:itemDict.copy];
        }

        // Gather addon item names
        container = station[OGElement.addonItemContainerClass].firstObject;
        for (OGElement *addon in container[OGElement.addonItemClass]) {
            [addons addObject:addon[OGElement.itemNameClass].firstObject.text];
        }

        // Create station
        [stations addObject:@{@"name": title, @"foodItems": items, @"additionalItems": addons}];
    }

    return json;
}

@end
