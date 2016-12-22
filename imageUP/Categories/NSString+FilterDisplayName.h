//
//  NSString+FilterDisplayName.h
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Filter) {
    FilterSepia,
    FilterInvert,
    FilterPosterize,
    FilterMonochrome,
    FilterBlur,
    FilterFade,
    FilterNoir,
    FilterCrystallize,
    FilterInstant,
    FilterComic,
    FilterCount
};

@interface NSString (FilterDisplayName)
+ (NSString *)displayNameForFilter:(Filter)filter;

@end
