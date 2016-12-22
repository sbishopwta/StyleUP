//
//  FilterSelectionCollectionViewCell.h
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSelectionCollectionViewCell : UICollectionViewCell
- (void)configureWithFilterName:(NSString *)filterName andImageName:(NSString *)imageName;

@end
