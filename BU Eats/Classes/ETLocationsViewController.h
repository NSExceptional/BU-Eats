//
//  ETLocationsViewController.h
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUDiningMenu.h"
#import "CDEatery.h"

@interface ETLocationsViewController : UITableViewController

+ (instancetype)locations:(NSArray<CDEatery *> *)locations;

- (void)applyTheme;
- (void)showHours;
- (void)showLocation:(BaylorEatery)eatery;

@end
