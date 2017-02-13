//
//  Filter.m
//  styleUP
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
        _identifier = [NSString stringWithFormat:@"%@%@%@", displayName, filterName, imageName];
    }
    return self;
}

@end

@implementation Filter

+ (FilterComposite *)displayNameForFilter:(FilterType)filterType {
    switch (filterType) {
        case FilterTypeSepia:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.Sepia", nil)  filterName:@"CISepiaTone" andImageName:@"filter3"];
        case FilterTypeColorInvert:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.ColorInvert", nil) filterName:@"CIColorInvert" andImageName:@"filter3"];
        case FilterTypePosterize:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.Posterize", nil) filterName:@"CIColorPosterize" andImageName:@"filter3"];
        case FilterTypeMonochrome:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.Monochrome", nil) filterName:@"CIColorMonochrome" andImageName:@"filter3"];
        case FilterTypeMotionBlur:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.MotionBlur", nil) filterName:@"CIMotionBlur" andImageName:@"filter3"];
        case FilterTypePhotoEffectFade:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.Fade", nil) filterName:@"CIPhotoEffectFade" andImageName:@"filter3"];
        case FilterTypePhotoEffectNoir:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.Noir", nil) filterName:@"CIPhotoEffectNoir" andImageName:@"filter3"];
        case FilterTypeCrystallize:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.Crystallize", nil) filterName:@"CICrystallize" andImageName:@"filter3"];
        case FilterTypePhotoEffectInstant:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.Instant", nil) filterName:@"CIPhotoEffectInstant" andImageName:@"filter3"];
        case FilterTypeComicEffect:
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.Comic", nil) filterName:@"CIComicEffect" andImageName:@"filter3"];
        default:
            NSLog(@"Display name case %li not handled", (long)filterType);
            return [[FilterComposite alloc] initWithDisplayName:NSLocalizedString(@"Filter.Name.Sepia", nil) filterName:@"CISepiaTone" andImageName:@"filter1"];
    }
}

@end








