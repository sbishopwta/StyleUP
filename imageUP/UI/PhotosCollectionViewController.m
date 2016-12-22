//
//  PhotosCollectionViewController.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "FilterSelectionCollectionViewController.h"
#import "PhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import <Photos/Photos.h>
#import "PHAsset+ImageKey.h"
#import "UICollectionViewCell+ReusableIdentifier.h"

@interface PhotosCollectionViewController () <FilterDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *allPhotos;
@property (strong, nonatomic) PHCachingImageManager *imageCachingManager;
@property (strong, nonatomic) CIContext *context;
@property (copy, nonatomic) NSString *filterName;
@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation PhotosCollectionViewController

NSString * const PhotoSortDescriptorKey = @"creationDate";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setupNavigationBar];
    [self requestPhotoAssets];
    [self configureItemSize];
}

- (void)setup {
    self.cache = [NSCache new];
    self.operationQueue = [NSOperationQueue new];
    [NSOperationQueue mainQueue].maxConcurrentOperationCount = 50;
    self.operationQueue.maxConcurrentOperationCount = 50;
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
    self.context = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    self.imageCachingManager = [PHCachingImageManager new];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier]];
}

- (void)setupNavigationBar {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navTitle"]];
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ActionButton.Filter", nil).uppercaseString
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(presentFilterSelectionController)];
    self.navigationItem.rightBarButtonItem = filterButton;
}

- (void)presentFilterSelectionController {
    FilterSelectionCollectionViewController *filterSelectionController = [FilterSelectionCollectionViewController buildWithDelegate:self];
    UINavigationController *filterSelectionNavigationController = [[UINavigationController alloc] initWithRootViewController:filterSelectionController];
    [self.navigationController presentViewController:filterSelectionNavigationController animated:YES completion:nil];
}

- (void)requestPhotoAssets {
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:PhotoSortDescriptorKey ascending:false]];
    self.allPhotos = [PHAsset fetchAssetsWithOptions:fetchOptions];
}

- (void)configureItemSize {
    CGSize screenSize = self.view.frame.size;
    NSInteger numberOfColumns = 4;
    double sectionInsetPadding = self.flowLayout.sectionInset.left + self.flowLayout.sectionInset.right;
    double cellDimension = ((screenSize.width - sectionInsetPadding) / numberOfColumns) - self.flowLayout.minimumLineSpacing;
    CGSize cellSize = CGSizeMake(cellDimension,
                                 cellDimension);
    self.flowLayout.itemSize = cellSize;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier]
                                                                              forIndexPath:indexPath];
    
    PHAsset *imageAsset = [self.allPhotos objectAtIndex:indexPath.item];
    cell.imageIdentifier = imageAsset.localIdentifier;
    NSString *filteredImageKey = [imageAsset imageKeyFromFilterName:self.filterName];
    NSString *unfilteredImageKey = [imageAsset imageKeyForUnfilteredImage];
    UIImage *cachedFilteredImage = [self.cache objectForKey:filteredImageKey];
    UIImage *cachedUnfilteredImage = [self.cache objectForKey:unfilteredImageKey];
    
    if (cachedFilteredImage == nil && cachedUnfilteredImage == nil) {
        [self requestImage:imageAsset forCell:cell];
        
    } else if (cachedUnfilteredImage && cachedFilteredImage == nil) {
        [self filterImage:imageAsset forCell:cell unfilteredImage:cachedUnfilteredImage];
    }
    
    else if (cachedFilteredImage) {
        if ([cell.imageIdentifier isEqualToString:imageAsset.localIdentifier]) {
            [cell configureWithImage:cachedFilteredImage];
        }
    }
    
    return cell;
}

#pragma mark - Image Requests

- (void)filterImage:(PHAsset *)imageAsset forCell:(PhotoCollectionViewCell *)cell unfilteredImage:(UIImage *)unfilteredImage {
    __weak typeof(self) weakSelf = self;
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        CIImage *ciImage = [[CIImage alloc] initWithImage:unfilteredImage options:@{kCIContextWorkingColorSpace:[NSNull null]}];
        UIImage *filteredImage = [weakSelf processImageWithFilter:weakSelf.filterName image:ciImage asset:imageAsset];
        if (filteredImage != nil) {
            [weakSelf.cache setObject:filteredImage forKey:[imageAsset imageKeyFromFilterName:weakSelf.filterName]];
        } else {
            NSLog(@"filteredImage was nil for key: %@", [imageAsset imageKeyFromFilterName:weakSelf.filterName]);
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([cell.imageIdentifier isEqualToString:imageAsset.localIdentifier]) {
                [cell configureWithImage:filteredImage];
            }
        }];
    }];
    operation.queuePriority = NSOperationQueuePriorityVeryHigh;
    [self.operationQueue addOperation:operation];
}

- (void)requestImage:(PHAsset *)imageAsset forCell:(PhotoCollectionViewCell *)cell {
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    __weak typeof(self) weakSelf = self;
    
    [self.imageCachingManager requestImageForAsset:imageAsset targetSize:self.flowLayout.itemSize
                                       contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

                                           if (result != nil) {
                                               [self.cache setObject:result forKey:[imageAsset imageKeyFromFilterName:UnfilteredImageKey]];
                                           } else {
                                               NSLog(@"result was nil for key: %@", [imageAsset imageKeyFromFilterName:UnfilteredImageKey]);
                                           }
                                           
                                           if (weakSelf.filterName) {
                                               [weakSelf filterImage:imageAsset forCell:cell unfilteredImage:result];
                                           } else if ([cell.imageIdentifier isEqualToString:imageAsset.localIdentifier] && weakSelf.filterName == nil) {
                                               [cell configureWithImage:result];
                                           }
                                       }];
}

#pragma mark - Filter Proccessing

- (UIImage *)processImageWithFilter:(NSString *)filterName image:(CIImage *)ciImage asset:(PHAsset *)imageAsset
{
    NSString *imageKey = [imageAsset imageKeyFromFilterName:self.filterName];
    UIImage *cachedImage = [self.cache objectForKey:imageKey];
    
    if (cachedImage == nil) {
        CIFilter *filter = [CIFilter filterWithName:filterName];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        CGImageRef cgImage = [self.context createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
        UIImage *newImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        if (newImage != nil) {
            [self.cache setObject:newImage forKey:imageKey];
        } else {
            NSLog(@"newImage was nil for key: %@", imageKey);
        }
        
        return newImage;
    } else {
        return cachedImage;
    }
}

#pragma mark - Filter Delegate

- (void)didSelectFilter:(NSString *)filterName {
    self.filterName = filterName;
    [self.collectionView reloadItemsAtIndexPaths:self.collectionView.indexPathsForVisibleItems];
}

- (void)resetFilter {
    self.filterName = nil;
    [self.collectionView reloadItemsAtIndexPaths:self.collectionView.indexPathsForVisibleItems];
}

@end
