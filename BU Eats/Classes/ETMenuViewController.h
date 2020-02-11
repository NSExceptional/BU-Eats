//
//  ETMenuViewController.h
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDEatery.h"
#import "CDFoodStation.h"

@interface ETMenuViewController : UITableViewController

+ (instancetype)emptyMenuForLocation:(CDEatery *)location;
- (void)updateSections:(NSArray<CDFoodStation *> *)foodStations animated:(BOOL)animated;

- (void)clear;

@end
