//
//  UIColor+BU.h
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BU)

+ (UIStatusBarStyle)statusBarStyle;

+ (instancetype)globalTint;

+ (instancetype)viewBackgroundColor;

+ (instancetype)cellBackgroundColor;
+ (instancetype)cellTextColor;
+ (instancetype)cellDetailTextColor;
+ (instancetype)separatorLineColor;

+ (instancetype)titleTextColor;
+ (instancetype)barBackgroundColors;
+ (instancetype)tabDeselectedColor;

+ (instancetype)datePickerTintColor;

@end
