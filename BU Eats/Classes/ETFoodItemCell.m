//
//  ETFoodItemCell.m
//  BU Eats
//
//  Created by Tanner on 9/4/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "ETFoodItemCell.h"

@implementation ETFoodItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.numberOfLines = 0;
    }

    return self;
}

@end
