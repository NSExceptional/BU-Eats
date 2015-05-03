//
//  ETMealTabController.h
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETLocation.h"
#import "DIDatePicker.h"

@interface ETMealTabController : UITabBarController

+ (instancetype)mealsForLocation:(Eatery)location;
- (void)applyTheme;

@property (nonatomic) DIDatepicker *datePicker;

@end
