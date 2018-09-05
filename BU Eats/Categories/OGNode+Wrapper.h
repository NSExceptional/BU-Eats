//
//  OGNode+Wrapper.h
//  BU Eats
//
//  Created by Tanner on 8/28/18.
//Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import <ObjectiveGumbo/ObjectiveGumbo.h>

@class ETNode, ETElement;

@interface OGNode (Wrapper)

- (NSArray<OGElement*> *)objectForKeyedSubscript:(NSString *)key;
- (NSArray<OGElement*> *)objectAtIndexedSubscript:(NSInteger)key;

@end
