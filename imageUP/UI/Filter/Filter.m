//
//  Filter.m
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "Filter.h"

@implementation FilterComposite

- (instancetype)initWithDisplayName:(NSString *)displayName filterName:(NSString *)filterName andImageName:(NSString *)imageName {
    if (self = [super init]) {
        _displayName = displayName;
        _filterName = filterName;
        _imageName = imageName;
    }
    return self;
}

@end


@implementation Filter

+ (FilterComposite *)displayNameForFilter:(FilterType)filterType {
    switch (filterType) {
        case FilterTypeSepia:
            return [[FilterComposite alloc] initWithDisplayName:@"Sepia" filterName:@"CISepiaTone" andImageName:@"filter1"];
        case FilterTypeColorInvert:
            return [[FilterComposite alloc] initWithDisplayName:@"Color Invert" filterName:@"CIColorInvert" andImageName:@"filter2"];
        case FilterTypePosterize:
            return [[FilterComposite alloc] initWithDisplayName:@"Posterize" filterName:@"CIColorPosterize" andImageName:@"filter3"];
        case FilterTypeMonochrome:
            return [[FilterComposite alloc] initWithDisplayName:@"Monochrome" filterName:@"CIColorMonochrome" andImageName:@"filter4"];
        case FilterTypeMotionBlur:
            return [[FilterComposite alloc] initWithDisplayName:@"Motion Blur" filterName:@"CIMotionBlur" andImageName:@"filter5"];
        case FilterTypePhotoEffectFade:
            return [[FilterComposite alloc] initWithDisplayName:@"Fade" filterName:@"CIPhotoEffectFade" andImageName:@"filter6"];
        case FilterTypePhotoEffectNoir:
            return [[FilterComposite alloc] initWithDisplayName:@"Noir" filterName:@"CIPhotoEffectNoir" andImageName:@"filter1"];
        case FilterTypeCrystallize:
            return [[FilterComposite alloc] initWithDisplayName:@"Crystallize" filterName:@"CICrystallize" andImageName:@"filter2"];
        case FilterTypePhotoEffectInstant:
            return [[FilterComposite alloc] initWithDisplayName:@"Instant" filterName:@"CIPhotoEffectInstant" andImageName:@"filter3"];
        case FilterTypeComicEffect:
            return [[FilterComposite alloc] initWithDisplayName:@"Comic" filterName:@"CIComicEffect" andImageName:@"filter4"];
        default:
            NSLog(@"Display name case %li not handled", (long)filterType);
            return [[FilterComposite alloc] initWithDisplayName:@"Sepia" filterName:@"CISepiaTone" andImageName:@"filter1"];
    }
}

@end








