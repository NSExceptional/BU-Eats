//
//  ETHOOP.h
//  BU Eats
//
//  Created by Tanner on 8/2/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BUDiningMenu.h"

@interface ETHOOP : NSObject

+ (instancetype)fromData:(NSData *)plistData error:(out NSError **)error;

- (NSArray *)hoopForEatery:(BaylorEatery)eatery;

@property (nonatomic, readonly) NSDictionary *hoopByEatery;
@property (nonatomic, readonly) NSDictionary *overridesByEatery;
@property (nonatomic, readonly) NSDictionary *messagesByEatery;


@end
