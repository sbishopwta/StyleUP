//
//  UICollectionViewCell+ReusableIdentifier.m
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "UICollectionViewCell+ReusableIdentifier.h"

@implementation UICollectionViewCell (ReusableIdentifier)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
