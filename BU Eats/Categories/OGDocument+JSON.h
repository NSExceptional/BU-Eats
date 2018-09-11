//
//  OGDocument+JSON.h
//  BU Eats
//
//  Created by Tanner on 9/11/18.
//Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "OGDocument.h"

@interface OGDocument (JSON)

@property (nonatomic, readonly) NSDictionary *toJSON;

@end
