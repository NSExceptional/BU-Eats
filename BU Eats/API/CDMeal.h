//
//  CDMeal.h
//  BU Eats
//
//  Created by Tanner Bennett on 9/10/19.
//  Copyright © 2019 Tanner Bennett. All rights reserved.
//

#import "CDObject.h"

/// Represents a particular meal at a particular school.
/// Maybe even at a particular eatery within the same school.
/// Two schools could both have breackfast/lunch/dinner
/// but will absolutely have different IDs for each one.
@interface CDMeal : CDObject

@property (nonatomic, readonly, class) NSArray<CDMeal *> *baylorMeals;

@property (nonatomic, readonly) NSInteger identifier;
@property (nonatomic, readonly) NSString *name;

@end
