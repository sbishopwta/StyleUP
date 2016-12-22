//
//  FilterSelectionTableViewController.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "FilterSelectionTableViewController.h"
#import "FilterSelectionTableViewCell.h"




typedef NS_ENUM(NSInteger, Filter) {
    FilterSepia,
    FilterInvert,
    FilterPosterize,
    FilterCrossPolynomial,
    FilterCount
};

@interface FilterSelectionTableViewController ()
@property (strong, nonatomic) NSArray <NSString *> *filters;
@property (weak, nonatomic) id <FilterDelegate> delegate;
@end

@implementation FilterSelectionTableViewController

+ (instancetype)buildWithDelegate:(id<FilterDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([FilterSelectionTableViewController class]) bundle:nil];
    FilterSelectionTableViewController *filterContoller = storyboard.instantiateInitialViewController;
    filterContoller.filters = @[@"CISepiaTone", @"CIColorInvert", @"CIColorPosterize", @"CIColorCrossPolynomial"];
    filterContoller.delegate = delegate;
    return filterContoller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FilterSelectionTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FilterSelectionTableViewCell class])];
}

- (void)setupNavigationBar {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return FilterCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FilterSelectionTableViewCell class])];
    NSString *filterName = self.filters[indexPath.row];
    [cell configureWithFilterName:filterName];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *filterName = self.filters[indexPath.row];
    [self.delegate didSelectFilter:filterName];
    [self dismiss];
}

@end
