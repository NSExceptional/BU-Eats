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

/// Gold, used for bar button items
@property (nonatomic, readonly, class) UIColor *globalTint;
/// Green, used for tab bar items and the date picekr underline
@property (nonatomic, readonly, class) UIColor *greenTint;

@property (nonatomic, readonly, class) UIColor *viewBackgroundColor;
@property (nonatomic, readonly, class) UIColor *primaryTextColor;
@property (nonatomic, readonly, class) UIColor *secondaryTextColor;

@property (nonatomic, readonly, class) UIColor *titleTextColor;
@property (nonatomic, readonly, class) UIColor *barBackgroundColors;
@property (nonatomic, readonly, class) UIColor *safariVCBarBackgroundColor;
@property (nonatomic, readonly, class) UIColor *tabDeselectedColor;
@property (nonatomic, readonly, class) UIColor *separatorLineColor;

@property (nonatomic, readonly, class) UIColor *datePickerTintColor;
@property (nonatomic, readonly, class) UIColor *datePickerBackgroundColor;

@property (nonatomic, readonly, class) UIColor *spinnerColor;

@end
