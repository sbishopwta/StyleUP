//
//  PhotoCollectionViewCell.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "PhotoCollectionViewCell.h"


@interface PhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureWithImage:(UIImage *)image {
    self.imageView.image = image;
}



- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
