//
//  ETCreatedByViewController.m
//  BU Eats
//
//  Created by Tanner on 11/4/17.
//  Copyright © 2017 Tanner Bennett. All rights reserved.
//

#import "ETCreatedByViewController.h"
#import "UIViewController+Extensions.h"
#import "Masonry.h"

@implementation ETCreatedByViewController

- (void)loadView {
    [super loadView];

    NSString *message = @"Developed at the\n2015 Teal Hackathon by:\n\nTanner Bennett\nJustin Paul\nMegan Todd\nRachel Langdon\n\n\nContact: Tanner Bennett\ntanner_bennett@baylor.edu\n@NSExceptional";

    UILabel *label = [UILabel new];
    label.text = message;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:0.333 alpha:1];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:25.0];
//    [label sizeToFit];

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(label.superview);
        make.centerY.equalTo(label.superview).multipliedBy(1.0/(screenHeight/568.0));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyTheme];
    
    self.title = @"About";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    #warning TODO Not sure why I have to do this... I'm not setting it anywhere else
    self.navigationController.navigationBar.translucent = YES;

    // Dismissal
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(dismissAnimated)];
    self.navigationItem.rightBarButtonItem = dismiss;
}

- (void)applyTheme {
    self.view.backgroundColor = [UIColor viewBackgroundColor];
}

@end
