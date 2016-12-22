//
//  PhotoCollectionViewCell.h
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) NSString *imageIdentifier;
- (void)configureWithImage:(UIImage *)image;
@end
