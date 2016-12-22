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
@end

@implementation FilterSelectionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureWithFilterName:(NSString *)filterName {
    self.titleLabel.text = filterName;
}

@end
