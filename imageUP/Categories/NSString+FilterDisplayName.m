//
//  NSString+FilterDisplayName.m
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "NSString+FilterDisplayName.h"

@implementation NSString (FilterDisplayName)

+ (NSString *)displayNameForFilter:(Filter)filter {
    switch (filter) {
        case FilterSepia:
            return @"Sepia";
        case FilterInvert:
            return @"Color Invert";
        case FilterPosterize:
            return @"Posterize";
        case FilterMonochrome:
            return @"Monochrome";
        case FilterBlur:
            return @"Motion Blur";
        case FilterFade:
            return @"Fade";
        case FilterNoir:
            return @"Noir";
        case FilterCrystallize:
            return @"Crystallize";
        case FilterInstant:
            return @"Instant";
        case FilterComic:
            return @"Comic";
        default:
            NSLog(@"Display name case %li not handled", (long)filter);
            return @"";
    }
}

@end
