//
//  FilterSelectionCollectionViewCell.m
//  styleUP
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

- (void)configureWithFilterName:(NSString *)filterName andImage:(UIImage *)image {
    self.titleLabel.text = filterName;
    self.imageView.image = image;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = nil;
    self.imageView.image = nil;
}

@end
