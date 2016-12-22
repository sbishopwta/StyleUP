//
//  Theme.m
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "Theme.h"

@implementation Theme

CGFloat const ImageViewCornerRadius = 4.0f;

@end

@implementation UIFont (Helpers)

+ (UIFont *)primaryFont {
    return [UIFont fontWithName:@"ProximaNova-Regular" size: 16];
}

+ (UIFont *)primarySemiBoldFont {
    return [UIFont fontWithName:@"ProximaNova-Semibold" size: 20];
}

+ (UIFont *)primaryLightFont {
    return [UIFont fontWithName:@"ProximaNova-Light" size: 16];
}

@end

@implementation UIColor (Helpers)

+ (UIColor *)themeBrownColor {
    return [UIColor colorWithRed:169.0f / 255.0f green:146.0f / 255.0f blue:97.0f / 255.0f alpha:1.0f];
}

@end
