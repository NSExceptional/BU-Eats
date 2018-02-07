//
//  ETLocationsViewController.h
//  BU Eats
//
//  Created by Tanner on 4/24/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETLocationsViewController : UITableViewController
- (void)applyTheme;
- (void)showHours;
- (void)showLocation:(Eatery)eatery;
@end
