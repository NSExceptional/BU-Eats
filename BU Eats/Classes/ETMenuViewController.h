//
//  ETMenuViewController.h
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETLocation.h"

@interface ETMenuViewController : UITableViewController

+ (instancetype)emptyMenuForLocation:(Eatery)location;
+ (instancetype)menuForLocation:(Eatery)location sections:(NSArray *)sections items:(NSDictionary *)items;
- (void)updateSections:(NSArray *)sections andItems:(NSDictionary *)items animated:(BOOL)animated;
- (void)applyTheme;

- (void)clear;

@end
