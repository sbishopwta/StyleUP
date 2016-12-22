//
//  PhotosCollectionViewController.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "FilterSelectionTableViewController.h"
#import "PhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import <Photos/Photos.h>

@interface PHAsset (imageKey)
- (NSString *)imageKeyFromFilterName:(NSString *)filterName;
@end

@implementation PHAsset (imageKey)
- (NSString *)imageKeyFromFilterName:(NSString *)filterName {
    return [filterName stringByAppendingString:self.localIdentifier];
}

@end

@interface PhotosCollectionViewController () <PHPhotoLibraryChangeObserver, FilterDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *allPhotos;
@property (strong, nonatomic) PHCachingImageManager *imageCachingManager;
@property (nonatomic, strong) CIContext *context;
@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation PhotosCollectionViewController
const NSInteger numberOfColumns = 4;

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cache = [NSCache new];
    self.operationQueue = [NSOperationQueue new];
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
    self.context = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    
    self.imageCachingManager = [PHCachingImageManager new];
    [self setupNavigationBar];
    [self requestPhotoLibraryPermission];
    [self configureCollectionView];
}

- (void)setupNavigationBar {
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(presentFilterSelectionController)];
    self.navigationItem.rightBarButtonItem = filterButton;
}

- (void)presentFilterSelectionController {
    FilterSelectionTableViewController *filterSelectionController = [FilterSelectionTableViewController buildWithDelegate:self];
    UINavigationController *filterSelectionNavigationController = [[UINavigationController alloc] initWithRootViewController:filterSelectionController];
    [self.navigationController presentViewController:filterSelectionNavigationController animated:YES completion:nil];
}

- (void)requestPhotoLibraryPermission {
    PHFetchOptions *fetchOptions = [PHFetchOptions new];                        //may want to fetch a different asset collection
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
    self.allPhotos = [PHAsset fetchAssetsWithOptions:fetchOptions];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}


- (void)configureCollectionView {
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    
//    CGSize screenSize = self.view.frame.size;
//    double cellWidth = (screenSize.width / numberOfColumns);
//    double padding = screenSize.width - cellWidth * numberOfColumns;
//    CGSize cellSize = CGSizeMake(floor(screenSize.width/numberOfColumns) + padding,
//                                 floor(screenSize.height/numberOfColumns) + padding);
//    
//    self.flowLayout.itemSize = cellSize;
}

//[NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//    
//    // background thread code
//    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        
//        // Main thread work (UI usually)
//        
//    }];
//}];

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    
    PHAsset *imageAsset = [self.allPhotos objectAtIndex:indexPath.item];
    UIImage *cachedImage = [self.cache objectForKey:[imageAsset imageKeyFromFilterName:self.filterName]];
    if (cachedImage == nil) {
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        cell.imageIdentifier = imageAsset.localIdentifier;
        
        __weak typeof(self) weakSelf = self;
        
        [self.imageCachingManager requestImageForAsset:imageAsset targetSize:CGSizeMake(80, 80) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            if ([cell.imageIdentifier isEqualToString:imageAsset.localIdentifier]) {
//                [cell configureWithImage:result];
//            }
            
            
            
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
                [self.cache setObject:result forKey:[imageAsset imageKeyFromFilterName:weakSelf.filterName]];
            }
        }];
        
    } else {
        [cell configureWithImage:cachedImage];
    }
    
    return cell;
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
        [self.cache setObject:newImage forKey:imageKey];
        
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
