//
//  NSArray+Functional.m
//  BU Eats
//
//  Created by Tanner Bennett on 9/10/19.
//Copyright © 2019 Tanner Bennett. All rights reserved.
//

#import "NSArray+Functional.h"

@implementation NSArray (Functional)

- (NSArray *)mapped:(id(^)(id obj, NSUInteger idx))block {
    NSMutableArray *map = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id ret = block(obj, idx);
        if (ret) {
            [map addObject:ret];
        }
    }];

    return map;
}

- (NSArray *)filtered:(BOOL(^)(id obj, NSUInteger idx))block {
    return [self mapped:^id (id obj, NSUInteger idx) {
        return block(obj, idx) ? obj : nil;
    }];
}

@end
