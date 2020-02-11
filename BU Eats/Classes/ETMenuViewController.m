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
#import "CDMealPeriod.h"

@interface ETMenuViewController ()
@property (nonatomic, readonly) CDMeal *meal;
@property (nonatomic, readonly) CDEatery *location;
@property (nonatomic) NSArray<CDFoodStation *> *foodStations;

@property (nonatomic) NSString *placeholderText;
@property (nonatomic) UILabel *placeholderLabel;
@end

@implementation ETMenuViewController

+ (instancetype)emptyMenuForLocation:(CDEatery *)location meal:(CDMeal *)meal {
    return [[ETMenuViewController alloc] initWithLocation:location meal:meal sections:nil];
}

- (id)initWithLocation:(CDEatery *)location meal:(CDMeal *)meal sections:(NSArray<CDFoodStation *> *)foodStations {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _meal = meal;
        _location = location;
        _foodStations = foodStations;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.location.name;
    self.tabBarItem.title = self.meal.name;
    self.tabBarItem.image = [CDMealPeriod iconForMeal:self.meal];
    
    [self.tableView registerClass:[ETFoodItemCell class] forCellReuseIdentifier:@"MenuItemCell"];
}

- (void)updateSections:(NSArray<CDFoodStation *> *)foodStations animated:(BOOL)animated {
    NSUInteger previousSections = _foodStations.count;
    _foodStations = foodStations;
    
    if (foodStations.count == 0) {
        self.placeholderText = @"This meal is not being served right now.";
    } else {
        self.placeholderText = nil;
        
        if (self.viewIfLoaded.window) {
            if (animated) {
                [self.tableView beginUpdates];
                NSUInteger numSectionsToInsert = foodStations.count > previousSections ? foodStations.count - previousSections : 0;
                NSUInteger numSectionsToRemove = previousSections > foodStations.count ? previousSections - foodStations.count : 0;
                [self.tableView reloadSections:NSIndexSetRanged(0, previousSections) withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertSections:NSIndexSetRanged(previousSections, numSectionsToInsert) withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView deleteSections:NSIndexSetRanged(previousSections - numSectionsToRemove, numSectionsToRemove) withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            } else {
                [self.tableView reloadData];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    if (self.placeholderLabel) {
        self.placeholderLabel.center = self.view.center;
    }
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
