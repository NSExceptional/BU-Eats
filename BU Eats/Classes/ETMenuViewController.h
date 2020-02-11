//
//  ETMenuViewController.h
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDMeal.h"
#import "CDEatery.h"
#import "CDFoodStation.h"

@interface ETMenuViewController : UITableViewController

+ (instancetype)emptyMenuForLocation:(CDEatery *)location meal:(CDMeal *)meal;
- (void)updateSections:(NSArray<CDFoodStation *> *)foodStations animated:(BOOL)animated;

- (void)clear;

@end
