//
//  FilterSelectionTableViewCell.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "FilterSelectionTableViewCell.h"

@interface FilterSelectionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FilterSelectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureWithFilterName:(NSString *)filterName {
    self.titleLabel.text = filterName;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = nil;
}


@end
