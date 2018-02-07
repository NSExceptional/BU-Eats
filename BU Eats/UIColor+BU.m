//
//  UIColor+BU.m
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "UIColor+BU.h"

@implementation UIColor (BU)

+ (UIStatusBarStyle)statusBarStyle {
    return UIStatusBarStyleLightContent;
}

+ (instancetype)globalTint {
    return [UIColor colorWithRed:0.931 green:0.768 blue:0.000 alpha:1.000];
}

+ (instancetype)viewBackgroundColor {
    return [UIColor colorWithWhite:0.955 alpha:1.000];
}

+ (instancetype)cellBackgroundColor {
    return [UIColor whiteColor];
}

+ (instancetype)cellTextColor {
    return [UIColor blackColor];
}

+ (instancetype)cellDetailTextColor {
    return [UIColor colorWithWhite:0.000 alpha:0.500];
}

+ (instancetype)separatorLineColor {
    return [UIColor colorWithWhite:0.000 alpha:0.500];
}

+ (instancetype)titleTextColor {
    return [UIColor whiteColor];
}

+ (instancetype)barBackgroundColors {
//    return [UIColor colorWithRed:0.07 green:0.27 blue:0.19 alpha:1.000];
    return [UIColor colorWithRed:0.06 green:0.23 blue:0.16 alpha:1.0];
}

+ (instancetype)tabDeselectedColor {
    return [UIColor greenColor];
}

+ (instancetype)datePickerTintColor {
    return [UIColor globalTint];
}


@end
