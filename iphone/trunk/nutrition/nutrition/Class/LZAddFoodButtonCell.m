//
//  LZAddFoodButtonCell.m
//  nutrition
//
//  Created by liu miao on 6/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZAddFoodButtonCell.h"

@implementation LZAddFoodButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];

    [self.addButton setHighlighted:highlighted];
}

@end
