//
//  FilterSelectionTableViewController.h
//  styleUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterDelegate <NSObject>
- (void)didSelectFilter:(NSString *)filterName;
- (void)resetFilter;
@end


@interface FilterSelectionCollectionViewController : UICollectionViewController
+ (instancetype)buildWithDelegate:(id<FilterDelegate>)delegate;

@end
