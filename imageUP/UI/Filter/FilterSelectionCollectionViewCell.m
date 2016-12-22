//
//  FilterSelectionCollectionViewCell.m
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "FilterSelectionCollectionViewCell.h"

@interface FilterSelectionCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FilterSelectionCollectionViewCell

- (void)configureWithFilterName:(NSString *)filterName andImageName:(NSString *)imageName {
    self.titleLabel.text = filterName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
