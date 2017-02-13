//
//  FilterSelectionCollectionViewCell.h
//  styleUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSelectionCollectionViewCell : UICollectionViewCell
@property (copy, nonatomic) NSString *imageIdentifier;

- (void)configureWithFilterName:(NSString *)filterName andImage:(UIImage *)image;

@end
