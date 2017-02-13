//
//  PHAsset+ImageKey.h
//  styleUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <Photos/Photos.h>

extern NSString * const UnfilteredImageKey;

@interface PHAsset (ImageKey)
- (NSString *)imageKeyFromFilterName:(NSString *)filterName;
- (NSString *)imageKeyForUnfilteredImage;
@end
