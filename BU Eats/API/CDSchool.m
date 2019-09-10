//
//  CDSchool.m
//  BU Eats
//
//  Created by Tanner on 9/15/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "CDSchool.h"

@implementation CDSchool

+ (instancetype)baylor {
    static CDSchool *baylor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baylor = [self new];
        baylor->_name = @"Baylor";
        baylor->_fullName = @"Baylor University";
        baylor->_identifier = @"319";
        baylor->_baseURL = @"https://baylor.campusdish.com";
    });

    return baylor;
}

@end
