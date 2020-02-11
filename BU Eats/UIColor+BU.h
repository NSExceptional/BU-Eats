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

@property (nonatomic, readonly, class) UIColor *globalTint;

@property (nonatomic, readonly, class) UIColor *viewBackgroundColor;
@property (nonatomic, readonly, class) UIColor *primaryTextColor;
@property (nonatomic, readonly, class) UIColor *secondaryTextColor;

@property (nonatomic, readonly, class) UIColor *titleTextColor;
@property (nonatomic, readonly, class) UIColor *barBackgroundColors;
@property (nonatomic, readonly, class) UIColor *tabDeselectedColor;
@property (nonatomic, readonly, class) UIColor *separatorLineColor;

@property (nonatomic, readonly, class) UIColor *datePickerTintColor;
@property (nonatomic, readonly, class) UIColor *datePickerBackgroundColor;

@property (nonatomic, readonly, class) UIColor *spinnerColor;

@end
