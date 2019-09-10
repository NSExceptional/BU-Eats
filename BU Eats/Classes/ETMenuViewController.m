//
//  ETMenuViewController.m
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETMenuViewController.h"
#import "ETFoodItemCell.h"
#import "CDFoodStation.h"

@interface ETMenuViewController ()
@property (nonatomic) CDEatery *location;
@property (nonatomic) NSArray<CDFoodStation *> *foodStations;

@property (nonatomic) NSString *placeholderText;
@property (nonatomic) UILabel *placeholderLabel;
@end

@implementation ETMenuViewController

+ (instancetype)emptyMenuForLocation:(CDEatery *)location {
    return [[ETMenuViewController alloc] initWithLocation:location sections:nil];
}

- (id)initWithLocation:(CDEatery *)location sections:(NSArray<CDFoodStation *> *)foodStations {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _location = location;
        _foodStations = foodStations;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = location.name;
        [self.tableView registerClass:[ETFoodItemCell class] forCellReuseIdentifier:@"MenuItemCell"];
    }
    
    return self;
}


- (void)updateSections:(NSArray<CDFoodStation *> *)foodStations animated:(BOOL)animated {
    if (foodStations.count == 0) {
        self.placeholderText = @"This meal is not being served right now.";
    } else {
        self.placeholderText = nil;

        if (animated) {
            [self.tableView beginUpdates];
            NSUInteger previousSections = _foodStations.count;
            _foodStations = foodStations;
            NSUInteger numSectionsToInsert = foodStations.count > previousSections ? foodStations.count - previousSections : 0;
            NSUInteger numSectionsToRemove = previousSections > foodStations.count ? previousSections - foodStations.count : 0;
            [self.tableView reloadSections:NSIndexSetRanged(0, previousSections) withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertSections:NSIndexSetRanged(previousSections, numSectionsToInsert) withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView deleteSections:NSIndexSetRanged(previousSections - numSectionsToRemove, numSectionsToRemove) withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        } else {
            foodStations = foodStations;
            [self.tableView reloadData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyTheme];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.placeholderLabel) {
        self.placeholderLabel.center = self.view.center;
    }
}

- (void)applyTheme {
    self.tableView.backgroundColor = [UIColor viewBackgroundColor];
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    
    if (placeholderText) {
        if (!_placeholderLabel) {
            _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            _placeholderLabel.text = placeholderText;
            _placeholderLabel.font = [UIFont systemFontOfSize:25];
            _placeholderLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
            _placeholderLabel.numberOfLines = 2;
            _placeholderLabel.textAlignment = NSTextAlignmentCenter;
            
            self.tableView.backgroundView = ({
                UIView *view = [UIView new];
                view.backgroundColor = self.tableView.backgroundColor;
                [view addSubview:_placeholderLabel];
                view;
            });
            
            CGSize size = [_placeholderLabel sizeThatFits:
                CGSizeMake([UIScreen mainScreen].bounds.size.width-60, CGFLOAT_MAX)
            ];
            _placeholderLabel.frame  = (CGRect){0, 0, size};
            _placeholderLabel.center = self.view.center;
            
        } else {
            _placeholderLabel.hidden = NO;
            _placeholderLabel.text = placeholderText;
        }
    } else {
        _placeholderLabel.hidden = YES;
    }
}

- (void)clear {
    self.foodStations = @[];
    [self.tableView reloadData];
}

#pragma mark UITableView protocols

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell" forIndexPath:indexPath];

    CDFoodStation *station = self.foodStations[indexPath.section];
    if (indexPath.row == station.foodItems.count) {
        // Case: additional items row
        cell.detailTextLabel.text = station.additionalItems;
    } else {
        // Case: regular item row
        CDFoodItem *item = station.foodItems[indexPath.row];
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = item.about;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.foodStations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CDFoodStation *station = self.foodStations[section];
    return station.foodItems.count + (station.additionalItems.length ? 1 : 0);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.foodStations[section].name;
}

@end
