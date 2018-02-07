//
//  ETHoursCell.m
//  BU Eats
//
//  Created by Tanner on 2/2/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "ETHoursCell.h"
#import "Masonry.h"

NSString * const kETHoursCellReuse = @"kETHoursCellReuse";

@implementation ETHoursCell

+ (BOOL)ETNeedsAutoLayoutFix {
    return [NSProcessInfo processInfo].operatingSystemVersion.majorVersion < 10;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithStyle:0 reuseIdentifier:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kETHoursCellReuse];
    if (self) {
        [self initialize];
    }

    return self;
}

- (void)initialize {
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.detailTextLabel.textColor = [UIColor blackColor];
    self.detailTextLabel.numberOfLines = 0;

    if (!ETDeviceIsSmall()) {
        self.textLabel.font = [self.textLabel.font fontWithSize:21];
        self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:15];
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return [self ETNeedsAutoLayoutFix];
}

- (void)updateConstraints {
    if ([[self class] ETNeedsAutoLayoutFix]) {
        UIEdgeInsets i = UIEdgeInsetsMake(10, 16, 12, 10);
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.textLabel.superview).insets(i);
        }];
        i.top = 5;
        [self.detailTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.detailTextLabel.superview).insets(i);
            make.top.equalTo(self.textLabel.mas_bottom).insets(i);
        }];
    }

    [super updateConstraints];
}

@end
