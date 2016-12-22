//
//  FilterSelectionTableViewController.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "FilterSelectionCollectionViewController.h"
#import "FilterSelectionCollectionViewCell.h"
#import "Filter.h"

@interface FilterSelectionCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) id <FilterDelegate> delegate;
@end

@implementation FilterSelectionCollectionViewController

+ (instancetype)buildWithDelegate:(id<FilterDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([FilterSelectionCollectionViewController class]) bundle:nil];
    FilterSelectionCollectionViewController *filterContoller = storyboard.instantiateInitialViewController;
    filterContoller.delegate = delegate;
    filterContoller.title = NSLocalizedString(@"FilterSelectionViewController.Title", nil);
    return filterContoller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FilterSelectionCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([FilterSelectionCollectionViewCell class])];
    CGSize screenSize = self.view.frame.size;
    NSInteger numberOfColumns = 2;
    double sectionInsetPadding = self.flowLayout.sectionInset.left + self.flowLayout.sectionInset.right;
    double cellDimension = ((screenSize.width - sectionInsetPadding) / numberOfColumns) - (self.flowLayout.minimumLineSpacing / numberOfColumns);
    CGSize cellSize = CGSizeMake(cellDimension,
                                 cellDimension);
    self.flowLayout.itemSize = cellSize;
}

- (void)setupNavigationBar {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ActionButton.Cancel", nil).uppercaseString
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ActionButton.Reset", nil).uppercaseString
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(reset)];
    self.navigationItem.leftBarButtonItem = resetButton;
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)reset {
    [self.delegate resetFilter];
    [self dismiss];
}

#pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return FilterTypeCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterSelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FilterSelectionCollectionViewCell class])
                                                                                        forIndexPath:indexPath];
    FilterComposite *filterComposite = [Filter displayNameForFilter:indexPath.item];
    [cell configureWithFilterName:filterComposite.displayName andImageName:filterComposite.imageName];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *filterName = [Filter displayNameForFilter:indexPath.item].filterName;
    [self.delegate didSelectFilter:filterName];
    [self dismiss];
}

@end
