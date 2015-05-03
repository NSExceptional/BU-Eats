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
        self.title = NSStringFromEatery(_location);
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuItemCell"];
    }
    
    return self;
}

- (void)updateSections:(NSArray *)sections andItems:(NSDictionary *)items {
    NSParameterAssert(sections.count > 0); NSParameterAssert(items.count > 0);
    NSParameterAssert(sections.count == items.count);
    
    [self.tableView beginUpdates];
    NSUInteger previousSections = _sectionTitles.count;
    _sectionTitles = sections;
    _itemsBySectionTitle = items;
    NSUInteger numSectionsToInsert = _sectionTitles.count > previousSections ? _sectionTitles.count - previousSections : 0;
    NSUInteger numSectionsToRemove = previousSections > _sectionTitles.count ? previousSections - _sectionTitles.count : 0;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, previousSections)] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(previousSections, numSectionsToInsert)] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(previousSections - numSectionsToRemove, numSectionsToRemove)] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyTheme];
}

- (void)applyTheme {
    self.tableView.backgroundColor = [UIColor viewBackgroundColor];
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
