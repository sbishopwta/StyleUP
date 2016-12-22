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

@interface PhotosCollectionViewController () <PHPhotoLibraryChangeObserver, FilterDelegate>
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
    [self configureCollectionView];
}

- (void)setup {
    self.cache = [NSCache new];
    self.operationQueue = [NSOperationQueue new];
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
    self.context = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    self.imageCachingManager = [PHCachingImageManager new];
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

- (void)configureCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier]];
    
    CGSize screenSize = self.view.frame.size;
    NSInteger numberOfColumns = 4;
    double cellDimension = ((screenSize.width - (self.flowLayout.sectionInset.left + self.flowLayout.sectionInset.right)) / numberOfColumns) - self.flowLayout.minimumLineSpacing;
    CGSize cellSize = CGSizeMake(cellDimension,
                                 cellDimension);
    self.flowLayout.itemSize = cellSize;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    PHAsset *imageAsset = [self.allPhotos objectAtIndex:indexPath.item];
    cell.imageIdentifier = imageAsset.localIdentifier;
    NSString *key = [imageAsset imageKeyFromFilterName:self.filterName];
    UIImage *cachedImage = [self.cache objectForKey:key];
    if (cachedImage == nil) {
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        
        
        __weak typeof(self) weakSelf = self;
        
        [self.imageCachingManager requestImageForAsset:imageAsset targetSize:self.flowLayout.itemSize
                                           contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                               
                                               
                                               
                                               if (weakSelf.filterName) {
                                                   NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                                                       CIImage *ciImage = [[CIImage alloc] initWithImage:result options:@{kCIContextWorkingColorSpace:[NSNull null]}];
                                                       UIImage *filteredImage = [weakSelf processImageWithFilter:weakSelf.filterName image:ciImage asset:imageAsset];
                                                       
                                                       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                           if ([cell.imageIdentifier isEqualToString:imageAsset.localIdentifier]) {
                                                               [cell configureWithImage:filteredImage];
                                                           }
                                                       }];
                                                   }];
                                                   
                                                   [self.operationQueue addOperation:operation];
                                                   
                                               } else {
                                                   if ([cell.imageIdentifier isEqualToString:imageAsset.localIdentifier]) {
                                                       [cell configureWithImage:result];
                                                   }
                                                   if (result != nil) {
                                                       [self.cache setObject:result forKey:[imageAsset imageKeyFromFilterName:weakSelf.filterName]];
                                                   }
                                               }
                                           }];
        
    } else {
        if ([cell.imageIdentifier isEqualToString:imageAsset.localIdentifier]) {
            [cell configureWithImage:cachedImage];
        }
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
   //cancel the queue?
}

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
        }
        
        return newImage;
    } else {
        return cachedImage;
    }
}

#pragma mark <PHPhotoLibraryChangeObserver>

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self.collectionView reloadData];
}

#pragma mark - Filter Delegate

- (void)didSelectFilter:(NSString *)filterName {
    self.filterName = filterName;
    [self.collectionView reloadItemsAtIndexPaths:self.collectionView.indexPathsForVisibleItems];
}

@end
