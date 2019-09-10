//
//  NSArray+Functional.h
//  BU Eats
//
//  Created by Tanner Bennett on 9/10/19.
//Copyright © 2019 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<T> (Functional)

/// Can work as map, flatmap, and filter, all in one.
/// Return nil from the block to omit an object.
- (NSArray *)mapped:(id _Nullable(^)(T obj, NSUInteger idx))block;
- (NSArray *)filtered:(BOOL(^)(T obj, NSUInteger idx))block;

@end

NS_ASSUME_NONNULL_END
