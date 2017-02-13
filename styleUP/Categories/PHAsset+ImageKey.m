//
//  PHAsset+ImageKey.m
//  styleUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "PHAsset+ImageKey.h"

NSString * const UnfilteredImageKey = @"UnfilteredImageKey";

@implementation PHAsset (ImageKey)

- (NSString *)imageKeyFromFilterName:(NSString *)filterName {
    if (filterName == nil) {
        filterName = UnfilteredImageKey;
    }
    return [NSString stringWithFormat:@"%@%@", filterName, self.localIdentifier];
}

- (NSString *)imageKeyForUnfilteredImage {
    return [NSString stringWithFormat:@"%@%@", UnfilteredImageKey, self.localIdentifier];
}

@end
