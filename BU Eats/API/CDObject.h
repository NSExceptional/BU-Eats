//
//  CDObject.h
//  BU Eats
//
//  Created by Tanner on 9/4/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface CDObject : MTLModel <MTLJSONSerializing>

+ (instancetype)fromJSON:(NSDictionary *)json;

- (void)postInit;

+ (NSValueTransformer *)JSONModelTransformerForClass:(Class)cls;
+ (NSValueTransformer *)JSONModelArrayTransformerForClass:(Class)cls;

//@property (nonatomic, readonly) NSDictionary *JSONValue;

@end
