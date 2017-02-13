//
//  ImageService.m
//  styleUP
//
//  Created by Steven Bishop on 12/26/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "ImageService.h"
#import "PHAsset+ImageKey.h"

@interface ImageService ()
@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) PHImageManager *imageManager;
@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@end

@implementation ImageService

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static ImageService* sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
        sharedInstance.cache = [NSCache new];
        sharedInstance.imageManager = [PHCachingImageManager new];
        sharedInstance.operationQueue = [NSOperationQueue new];
        sharedInstance.operationQueue.maxConcurrentOperationCount = 1; // prevents NSOperationQueue from performing too many operations that could cause a thread lock.
        EAGLContext *eAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] }; //Increases performance. Thumbnail sizes are too small to notice color management.
        sharedInstance.context = [CIContext contextWithEAGLContext:eAGLContext options:options];
    });

    return sharedInstance;
}

#pragma mark - Image Requests

- (void)imageForAsset:(PHAsset *)imageAsset imageSize:(CGSize)imageSize success:(void (^)(UIImage *image, NSString *imageIdentifier))imageHandler {
    NSString *filteredImageKey = [imageAsset imageKeyFromFilterName:self.filterName];
    NSString *unfilteredImageKey = [imageAsset imageKeyForUnfilteredImage];
    UIImage *cachedFilteredImage = [self.cache objectForKey:filteredImageKey];
    UIImage *cachedUnfilteredImage = [self.cache objectForKey:unfilteredImageKey];

    if (cachedFilteredImage == nil && cachedUnfilteredImage == nil) {
        [self requestImage:imageAsset imageSize:imageSize success:^(UIImage *image, NSString *imageIdentifier) {
            imageHandler(image, imageIdentifier);
        }];
    } else if (cachedUnfilteredImage && cachedFilteredImage == nil) {
        [self filterImage:cachedUnfilteredImage withAsset:imageAsset success:^(UIImage *filteredImage, NSString *imageIdentifier) {
            imageHandler(filteredImage, imageIdentifier);
        }];
    } else if (cachedFilteredImage) {
        imageHandler(cachedFilteredImage, imageAsset.localIdentifier);
    }
}

- (void)filterImage:(UIImage *)unfilteredImage withAsset:(PHAsset *)imageAsset success:(void (^)(UIImage *filteredImage, NSString *imageIdentifier))imageHandler  {
    __weak typeof(self) weakSelf = self;

    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        CIImage *ciImage = [[CIImage alloc] initWithImage:unfilteredImage options:@{kCIContextWorkingColorSpace:[NSNull null]}];
        UIImage *filteredImage = [weakSelf filterImage:ciImage];
        if (filteredImage != nil) {
            [weakSelf.cache setObject:filteredImage forKey:[imageAsset imageKeyFromFilterName:weakSelf.filterName]];
        }

        imageHandler(filteredImage, imageAsset.localIdentifier);
    }];
    operation.queuePriority = NSOperationQueuePriorityVeryHigh;
    [self.operationQueue addOperation:operation];
}

- (void)requestImage:(PHAsset *)imageAsset imageSize:(CGSize)imageSize success:(void (^)(UIImage *image, NSString *imageIdentifier))imageHandler {
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;

    __weak typeof(self) weakSelf = self;

    [self.imageManager requestImageForAsset:imageAsset targetSize:imageSize
                                contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

                                    if (result != nil) {
                                        [self.cache setObject:result forKey:[imageAsset imageKeyFromFilterName:UnfilteredImageKey]];
                                    }

                                    if (weakSelf.filterName) {
                                        [weakSelf filterImage:result withAsset:imageAsset success:^(UIImage *filteredImage, NSString *imageIdentifier) {
                                            imageHandler(filteredImage, imageIdentifier);
                                        }];
                                    } else {
                                        imageHandler(result, imageAsset.localIdentifier);
                                    }
                                }];
}

- (void)filterImage:(UIImage *)image withFilterName:(NSString *)filterName imageIdentifier:(NSString *)imageIdentifier success:(void (^)(UIImage *filteredImage, NSString *imageIdentifier))imageHandler {

    UIImage *cachedFilteredImage = [self.cache objectForKey:imageIdentifier];

    if (cachedFilteredImage == nil) {
        __weak typeof(self) weakSelf = self;
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            CIImage *ciImage = [[CIImage alloc] initWithImage:image options:@{kCIContextWorkingColorSpace:[NSNull null]}];
            UIImage *filteredImage = [weakSelf filterImage:ciImage filterName:filterName];
            if (filteredImage != nil) {
                [weakSelf.cache setObject:filteredImage forKey:imageIdentifier];
            }

            imageHandler(filteredImage, imageIdentifier);
        }];
        operation.queuePriority = NSOperationQueuePriorityVeryHigh;
        [self.operationQueue addOperation:operation];
    } else {
        imageHandler(cachedFilteredImage, imageIdentifier);
    }
}

#pragma mark - Filter Proccessing

- (UIImage *)filterImage:(CIImage *)ciImage {
    return [self filterImage:ciImage filterName:self.filterName];
}

- (UIImage *)filterImage:(CIImage *)ciImage filterName:(NSString *)filterName {
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    CGImageRef cgImage = [self.context createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return filteredImage;
}

@end
