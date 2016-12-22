//
//  PHAsset+ImageKey.m
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "PHAsset+ImageKey.h"

@implementation PHAsset (ImageKey)

- (NSString *)imageKeyFromFilterName:(NSString *)filterName {
    return [NSString stringWithFormat:@"%@%@", filterName, self.localIdentifier];
}

@end
