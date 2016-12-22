//
//  Filter.h
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FilterType) {
    FilterTypeSepia,
    FilterTypeColorInvert,
    FilterTypePosterize,
    FilterTypeMonochrome,
    FilterTypeMotionBlur,
    FilterTypePhotoEffectFade,
    FilterTypePhotoEffectNoir,
    FilterTypeCrystallize,
    FilterTypePhotoEffectInstant,
    FilterTypeComicEffect,
    FilterTypeCount
};

@interface FilterComposite : NSObject
@property (copy, nonatomic) NSString *displayName;
@property (copy, nonatomic) NSString *filterName;
@property (copy, nonatomic) NSString *imageName;

- (instancetype)initWithDisplayName:(NSString *)displayName
                         filterName:(NSString *)filterName
                       andImageName:(NSString *)imageName;
@end

@interface Filter : NSObject
+ (FilterComposite *)displayNameForFilter:(FilterType)filterType;

@end


