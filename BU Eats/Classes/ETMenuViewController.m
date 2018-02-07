//
//  ETMenuViewController.m
//  BU Eats
//
//  Created by Tanner on 4/25/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "ETMenuViewController.h"

@interface ETMenuViewController ()
@property (nonatomic) Eatery       location;
@property (nonatomic) NSArray      *sectionTitles;
@property (nonatomic) NSDictionary *itemsBySectionTitle;

@property (nonatomic) NSString *placeholderText;
@property (nonatomic) UILabel *placeholderLabel;
@end

@implementation ETMenuViewController

+ (instancetype)emptyMenuForLocation:(Eatery)location {
    return [[ETMenuViewController alloc] initWithLocation:location sections:nil items:nil];
}

+ (instancetype)menuForLocation:(Eatery)location sections:(NSArray *)sections items:(NSDictionary *)items {
    NSParameterAssert(sections.count > 0); NSParameterAssert(items.count > 0);
    NSParameterAssert(sections.count == items.count);
    return [[ETMenuViewController alloc] initWithLocation:location sections:sections items:items];
}

- (id)initWithLocation:(Eatery)location sections:(NSArray *)sections items:(NSDictionary *)items {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _location = location;
        _sectionTitles = sections;
        _itemsBySectionTitle = items;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = ETStringFromEatery(_location);
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuItemCell"];
    }
    
    return self;
}

- (void)updateSections:(NSArray *)sections andItems:(NSDictionary *)items animated:(BOOL)animated {
    NSParameterAssert(sections.count == items.count);
    
    if (sections.count == 0) {
        self.placeholderText = @"This meal is not being served right now.";
    } else {
        self.placeholderText = nil;

        if (animated) {
            [self.tableView beginUpdates];
            NSUInteger previousSections = _sectionTitles.count;
            _sectionTitles = sections;
            _itemsBySectionTitle = items;
            NSUInteger numSectionsToInsert = _sectionTitles.count > previousSections ? _sectionTitles.count - previousSections : 0;
            NSUInteger numSectionsToRemove = previousSections > _sectionTitles.count ? previousSections - _sectionTitles.count : 0;
            [self.tableView reloadSections:NSIndexSetRanged(0, previousSections) withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertSections:NSIndexSetRanged(previousSections, numSectionsToInsert) withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView deleteSections:NSIndexSetRanged(previousSections - numSectionsToRemove, numSectionsToRemove) withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        } else {
            _sectionTitles = sections;
            _itemsBySectionTitle = items;
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
    if (_placeholderLabel)
        _placeholderLabel.center = self.view.center;
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
            
            self.tableView.backgroundView = ({UIView *view = [UIView new]; view.backgroundColor = self.tableView.backgroundColor; view;});
            [self.tableView.backgroundView addSubview:_placeholderLabel];
            
            CGSize size                  = [_placeholderLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-60, CGFLOAT_MAX)];
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
    self.sectionTitles = @[];
    self.itemsBySectionTitle = @{};
    [self.tableView reloadData];
}

#pragma mark UITableView protocols

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell" forIndexPath:indexPath];
    cell.textLabel.text   = self.itemsBySectionTitle[self.sectionTitles[indexPath.section]][indexPath.row];
    
    // Apply theme
    // Apply theme
    cell.backgroundColor = [UIColor cellBackgroundColor];
    cell.textLabel.textColor = [UIColor cellTextColor];
    cell.detailTextLabel.textColor = [UIColor cellDetailTextColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsBySectionTitle[self.sectionTitles[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

@end
