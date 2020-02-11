//
//  UIColor+BU.m
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "UIColor+BU.h"

#define DynamicColor(dynamic, static) ({ \
    UIColor *c; \
    if (@available(iOS 13.0, *)) { \
        c = [UIColor dynamic]; \
    } else { \
        c = [UIColor static]; \
    } \
    c; \
});

#define DynamicColorProvider(dark, light) ({ \
    UIColor *c; \
    if (@available(iOS 13, *)) { \
        c = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) { \
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) { \
                return [UIColor dark]; \
            } else { \
                return [UIColor light]; \
            } \
        }]; \
    } else { \
        c = [UIColor light]; \
    } \
    c; \
})

@implementation UIColor (BU)

+ (UIStatusBarStyle)statusBarStyle {
    return UIStatusBarStyleLightContent;
}

+ (UIColor *)globalTint {
    return [UIColor colorWithRed:0.931 green:0.768 blue:0.000 alpha:1.000];
}

+ (UIColor *)greenTint {
    return DynamicColorProvider(
        colorWithRed:0/255.f green: 135/255.f blue: 73/255.f alpha:1.0,
        colorWithRed:0.06 green:0.23 blue:0.16 alpha:1.0
    );
}

+ (UIColor *)viewBackgroundColor {
    return DynamicColor(groupTableViewBackgroundColor, colorWithWhite:0.955 alpha:1.000);
}

+ (UIColor *)primaryTextColor {
    return DynamicColor(labelColor, blackColor);
}

+ (UIColor *)secondaryTextColor {
    return DynamicColor(secondaryLabelColor, lightGrayColor);
}

+ (UIColor *)titleTextColor {
    return UIColor.whiteColor;
}

+ (UIColor *)barBackgroundColors {
    return DynamicColorProvider(systemBackgroundColor, colorWithRed:0.06 green:0.23 blue:0.16 alpha:1.0);
}

+ (UIColor *)safariVCBarBackgroundColor {
    return [UIColor colorWithRed:0.06 green:0.23 blue:0.16 alpha:1.0];
}

+ (UIColor *)tabDeselectedColor {
    return UIColor.greenColor;
}

+ (UIColor *)separatorLineColor {
    return DynamicColor(separatorColor, colorWithWhite:0.816 alpha:1.000);
}

+ (UIColor *)datePickerTintColor {
    return UIColor.globalTint;
}

+ (UIColor *)datePickerBackgroundColor {
    return DynamicColor(systemBackgroundColor, whiteColor);
}

+ (UIColor *)spinnerColor {
    return DynamicColor(labelColor, blackColor);
}

@end
