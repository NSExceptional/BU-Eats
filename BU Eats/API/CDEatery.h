//
//  CDEatery.h
//  BU Eats
//
//  Created by Tanner on 9/15/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDObject.h"
@class CDMeal;

@interface CDEatery : CDObject

@property (nonatomic, readonly, class) NSArray<CDEatery *> *baylorEateries;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *identifier;
// TODO check if this requires a transformer
//@property (nonatomic, readonly) BOOL openNow;
@property (nonatomic, readonly) NSString *hours;
@property (nonatomic, readonly) NSString *endpoint;

/// Set after initialization
@property (nonatomic) NSArray<CDMeal *> *meals;

@end
