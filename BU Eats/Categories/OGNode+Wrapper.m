//
//  OGNode+Wrapper.m
//  BU Eats
//
//  Created by Tanner on 8/28/18.
//Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "OGNode+Wrapper.h"

@implementation OGNode (Wrapper)

- (NSArray<OGElement*> *)objectForKeyedSubscript:(NSString *)key {
    return [self elementsWithClass:key];
}

- (NSArray<OGElement*> *)objectAtIndexedSubscript:(NSInteger)key {
    return [self elementsWithTag:(GumboTag)key];
}

@end
