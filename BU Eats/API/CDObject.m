//
//  CDObject.m
//  BU Eats
//
//  Created by Tanner on 9/4/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDObject.h"

@implementation CDObject

+ (instancetype)fromJSON:(NSDictionary *)json {
    return [[self alloc] initWithDictionary:json];
}

- (id)initWithDictionary:(NSDictionary *)json {
    NSParameterAssert(json.allKeys.count > 0);
    NSError *error = nil;
    self = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:json error:&error];

    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }

    NSParameterAssert((!error && self) || (error && !self));

    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];

    [self postInit];

    return self;
}

- (void)postInit { }

- (NSDictionary *)JSONValue {
    return [MTLJSONAdapter JSONDictionaryFromModel:self error:nil];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    static NSMutableDictionary<NSString*, NSDictionary*> *classesToMappings = nil;
    if (!classesToMappings) {
        classesToMappings = [NSMutableDictionary dictionary];
    }

    NSString *key = NSStringFromClass(self);
    NSDictionary *mapping = classesToMappings[key];
    if (!mapping) {
        mapping = [self computedJSONKeyPathsByPropertyKey];
        classesToMappings[key] = mapping;
    }

    return mapping;
}

+ (NSDictionary *)computedJSONKeyPathsByPropertyKey {
    NSSet<NSString*> *properties = [self propertyKeys];
    NSMutableDictionary *defaultMapping = [NSMutableDictionary dictionary];
    for (NSString *property in properties) {
        defaultMapping[property] = property;
    }

    return defaultMapping.copy;
}

+ (NSValueTransformer *)JSONModelArrayTransformerForClass:(Class)cls {
    NSParameterAssert([cls isSubclassOfClass:[CDObject class]]);

    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *models, BOOL *success, NSError **error) {
        return [MTLJSONAdapter modelsOfClass:cls fromJSONArray:models error:error];
    } reverseBlock:^id(NSArray *models, BOOL *success, NSError **error) {
        return [models valueForKeyPath:@"@unionOfObjects.JSONValue"];
    }];
}

+ (NSValueTransformer *)JSONModelTransformerForClass:(Class)cls {
    NSParameterAssert([cls isSubclassOfClass:[CDObject class]]);

    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *model, BOOL *success, NSError **error) {
        return [MTLJSONAdapter modelOfClass:cls fromJSONDictionary:model error:error];
    } reverseBlock:^id(CDObject *model, BOOL *success, NSError **error) {
        return model.JSONValue;
    }];
}

+ (NSValueTransformer *)cd_stringToNumberTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError **error) {
        return @(value.integerValue);
    } reverseBlock:^id(NSNumber *value, BOOL *success, NSError **error) {
        return value;
    }];
}

//+ (NSValueTransformer *)cd_UTCDateTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *ts, BOOL *success, NSError **error) {
//        return [NSDate dateWithTimeIntervalSince1970:ts.doubleValue];
//    } reverseBlock:^id(NSDate *ts, BOOL *success, NSError **error) {
//        return @(ts.timeIntervalSince1970).stringValue;
//    }];
//}

@end
