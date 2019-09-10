//
//  ETHOOP.m
//  BU Eats
//
//  Created by Tanner on 8/2/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETHOOP.h"
#import "ETTimeInterval.h"

@implementation ETHOOP

+ (instancetype)fromData:(NSData *)plistData error:(out NSError **)error {
    NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListMutableContainers format:NULL error:error];
    if (*error) return nil;
    return [[self alloc] initWithDictionary:plist];
}

- (id)initWithDictionary:(NSDictionary *)plist {
    NSParameterAssert(plist);
    
    self = [super init];
    if (self) {
        _hoopByEatery      = [self deserializedTimeIntervals:plist];
        _overridesByEatery = [self deserializedTimeIntervals:plist[@"overrides"]];
        _messagesByEatery  = plist[@"messages"];
    }
    
    return self;
}

- (NSDictionary *)deserializedTimeIntervals:(NSDictionary *)plist {
    if (!plist) return @{};
    
    [plist enumerateKeysAndObjectsUsingBlock:^(NSString *weekpart, NSMutableDictionary *values, BOOL *stop) {
        NSMutableArray *brooks      = values[ETStringFromEatery(EateryBrooks)];
        NSMutableArray *eastvillage = values[ETStringFromEatery(EateryEastVillage)];
        NSMutableArray *penland     = values[ETStringFromEatery(EateryPenland)];
        NSMutableArray *memorial    = values[ETStringFromEatery(EateryMemorial)];
        
        NSArray *locationsHOOPS = @[brooks, eastvillage, penland, memorial];
        for (NSMutableArray *location in locationsHOOPS) {
            for (NSInteger i = 0; i < location.count; i++) {
                NSDictionary *plistValue = location[i];
                location[i] = [ETTimeInterval timeIntervalFromPropertyListValue:plistValue];
            }
        }
        
        values[ETStringFromEatery(EateryBrooks)]      = brooks;
        values[ETStringFromEatery(EateryEastVillage)] = eastvillage;
        values[ETStringFromEatery(EateryPenland)]     = penland;
        values[ETStringFromEatery(EateryMemorial)]    = memorial;
    }];
    
    return plist;
}

- (NSArray *)hoopForEatery:(BaylorEatery)eatery {
    NSArray *hoop = self.overridesByEatery[ETStringFromEatery(eatery)];
    if (hoop.count) return hoop;
    return self.hoopByEatery[ETStringFromEatery(eatery)];
}

@end
