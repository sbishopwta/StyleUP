//
//  ImageService.h
//  styleUP
//
//  Created by Steven Bishop on 12/26/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ImageService : NSObject
@property (copy, nonatomic) NSString *filterName;

+ (instancetype)sharedInstance;

- (void)imageForAsset:(PHAsset *)imageAsset imageSize:(CGSize)imageSize success:(void (^)(UIImage *image, NSString *imageIdentifier))imageHandler;

- (void)filterImage:(UIImage *)image withFilterName:(NSString *)filterName imageIdentifier:(NSString *)imageIdentifier success:(void (^)(UIImage *filteredImage, NSString *imageIdentifier))imageHandler;

@end
