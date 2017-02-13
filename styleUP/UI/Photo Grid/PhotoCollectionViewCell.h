//
//  PhotoCollectionViewCell.h
//  styleUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (copy, nonatomic) NSString *imageIdentifier;

- (void)configureWithImage:(UIImage *)image;

@end
