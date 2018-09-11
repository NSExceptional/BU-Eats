//
//  CDClient.h
//  BU Eats
//
//  Created by Tanner on 9/4/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDClient : NSObject

+ (instancetype)sharedClient;

@property (nonatomic) NSString *currentLocationID;

@end
