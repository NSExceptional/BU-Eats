//
//  ETLocationCell.h
//  BU Eats
//
//  Created by Tanner on 4/26/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETLocationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *locationIcon;
@property (nonatomic, weak) IBOutlet UILabel     *locationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel     *statusLabel;

@end
