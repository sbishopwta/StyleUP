//
//  PhotoCollectionViewCell.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "Theme.h"


@interface PhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.imageView.layer.cornerRadius = CornerRadius;
//    self.imageView.layer.masksToBounds = YES;
}

- (void)configureWithImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = [UIImage imageNamed:@"filter5"];
}

@end
