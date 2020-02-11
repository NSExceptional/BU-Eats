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

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyTheme];
    
    self.title = @"About";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];

    // Dismissal
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        target:self
        action:@selector(dismissAnimated)
    ];
}

- (void)applyTheme {
//    self.view.backgroundColor = UIColor.viewBackgroundColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    
    NSString *message = @"Developed at the\n2015 Teal Hackathon by:\n\nTanner Bennett\nJustin Paul\nMegan Todd\nRachel Langdon\n\n\nContact: Tanner Bennett\ntanner_bennett@baylor.edu\n@NSExceptional";

    cell.textLabel.text = message;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:25.0];
    
    return cell;
}

@end
