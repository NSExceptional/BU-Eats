//
//  ETHoursViewController.m
//  BU Eats
//
//  Created by Tanner on 2/2/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

#import "ETHoursViewController.h"
#import "UIViewController+Extensions.h"
#import "ETHoursCell.h"
#import "ETLocation.h"
@import SafariServices;

NSString * const kAllHoursLink = @"https://raw.githubusercontent.com/NSExceptional/BU-Eats/master/BUEats-AllHoursURL.plist";
NSInteger const kOtherHoursSection = 1;
NSInteger const kDiningHallsSection = 0;


@interface ETHoursViewController ()
@property (nonatomic) NSURL *allHoursURL;
@property (nonatomic) NSArray<ETLocation*> *locations;
@end

@implementation ETHoursViewController

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Title, hours URL
    self.title = @"Hours of Operation";
    self.allHoursURL = [NSURL URLWithString:kDefaultAllHoursURL];

    // Get location objects
    _locations = ETEateries();

    // Table view stuff
    self.tableView.estimatedRowHeight = 85;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[ETHoursCell class] forCellReuseIdentifier:kETHoursCellReuse];

    // Register for emergency dismissal
    [[NSNotificationCenter defaultCenter]
     addObserverForName:kETModalsShouldDismissNotification
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         [self dismissViewControllerAnimated:NO completion:nil];
     }];

    // Try to get hours link
    NSURL *allHoursFileURL = [NSURL URLWithString:kAllHoursLink];
    [[[NSURLSession sharedSession] downloadTaskWithURL:allHoursFileURL completionHandler:^(NSURL *url, NSURLResponse *response, NSError *error) {
        if (url && [(NSHTTPURLResponse *)response statusCode] == 200) {
            self.allHoursURL = [NSURL URLWithString:[NSDictionary dictionaryWithContentsOfURL:url][@"URL"]];
        } else {
            NSLog(@"ETHoursViewController: could not load remote 'all hours URL' file.");
        }
    }] resume];

    // Done button
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(dismissAnimated)];
    self.navigationItem.rightBarButtonItem = dismiss;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)showAllHours {
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:self.allHoursURL];
    safari.preferredBarTintColor = UIColor.safariVCBarBackgroundColor;
    safari.preferredControlTintColor = UIColor.globalTint;

    [self presentViewController:safari animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETHoursCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kETHoursCellReuse forIndexPath:indexPath];

    // "All other locations" cell
    if (indexPath.section == kOtherHoursSection) {
        cell.textLabel.text = @"All other locations";
        cell.detailTextLabel.text = @"The SUB Food Court, Starbucks, etc.";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }

    ETLocation *location = self.locations[indexPath.row];
    cell.textLabel.text = location.name;
    cell.detailTextLabel.text = location.fullHours;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kOtherHoursSection:
            return 1;
        case kDiningHallsSection:
            return 4;
    }

    @throw NSInternalInconsistencyException;
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kOtherHoursSection) {
        return YES;
    }

    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    assert(indexPath.section == kOtherHoursSection);
    [self showAllHours];
}

@end
