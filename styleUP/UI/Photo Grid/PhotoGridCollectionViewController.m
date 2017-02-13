//
//  PhotoGridCollectionViewController.m
//  styleUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "FilterSelectionCollectionViewController.h"
#import "PhotoGridCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import <Photos/Photos.h>
#import "UICollectionViewCell+ReusableIdentifier.h"
#import "ImageService.h"

@interface PhotoGridCollectionViewController () <FilterDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *photos;

@end

@implementation PhotoGridCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self requestPhotoAssets];
    [self setupCollectionView];
}

- (void)setupNavigationBar {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navTitle"]];
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ActionButton.Filter", nil).uppercaseString
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(presentFilterSelectionController)];
    self.navigationItem.rightBarButtonItem = filterButton;
}

- (void)requestPhotoAssets {
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
    self.photos = [PHAsset fetchAssetsWithOptions:fetchOptions];
}

- (void)setupCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier]];

    CGSize collectionViewSize = self.collectionView.frame.size;
    NSInteger numberOfColumns = 4;
    double sectionInsetPadding = self.flowLayout.sectionInset.left + self.flowLayout.sectionInset.right;
    double cellDimension = ((collectionViewSize.width - sectionInsetPadding) / numberOfColumns) - self.flowLayout.minimumLineSpacing;
    CGSize cellSize = CGSizeMake(cellDimension,
                                 cellDimension);
    self.flowLayout.itemSize = cellSize;
}

#pragma mark - Actions

- (void)presentFilterSelectionController {
    FilterSelectionCollectionViewController *filterSelectionController = [FilterSelectionCollectionViewController buildWithDelegate:self];
    UINavigationController *filterSelectionNavigationController = [[UINavigationController alloc] initWithRootViewController:filterSelectionController];
    [self.navigationController presentViewController:filterSelectionNavigationController animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier]
                                                                              forIndexPath:indexPath];
    
    PHAsset *imageAsset = [self.photos objectAtIndex:indexPath.item];
    cell.imageIdentifier = imageAsset.localIdentifier;
    [[ImageService sharedInstance] imageForAsset:imageAsset
                                       imageSize:self.flowLayout.itemSize
                                         success:^(UIImage *image, NSString *imageIdentifier) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if ([imageIdentifier isEqualToString:cell.imageIdentifier]) {
                                                     [cell configureWithImage:image];
                                                 }
                                             });
                                         }];

    return cell;
}

#pragma mark - Filter Delegate

- (void)didSelectFilter:(NSString *)filterName {
    [[ImageService sharedInstance] setFilterName:filterName];
    [self.collectionView reloadItemsAtIndexPaths:self.collectionView.indexPathsForVisibleItems];
}

- (void)resetFilter {
    [[ImageService sharedInstance] setFilterName:nil];
    [self.collectionView reloadItemsAtIndexPaths:self.collectionView.indexPathsForVisibleItems];
}

@end
