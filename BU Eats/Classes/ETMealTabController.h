//
//  ETMealTabController.h
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDEatery.h"
#import "DIDatePicker.h"

@interface ETMealTabController : UITabBarController

+ (instancetype)mealsForLocation:(CDEatery *)location;
- (void)applyTheme;

@property (nonatomic) DIDatepicker *datePicker;

@end
