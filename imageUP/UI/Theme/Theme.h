//
//  Theme.h
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Theme : NSObject

extern CGFloat const ImageViewCornerRadius;
@end

@interface UIFont (Helpers)

+ (UIFont *)primaryFont;
+ (UIFont *)primarySemiBoldFont;
+ (UIFont *)primaryLightFont;

@end

@interface UIColor (Helpers)

+ (UIColor *)themeBrownColor;

@end
