//
//  LZDiseaseCell.m
//  nutrition
//
//  Created by liu miao on 9/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDiseaseCell.h"

@implementation LZDiseaseCell

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
    [self.sepratorLine setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    if (highlighted)
    {
        [self.nameLabel setTextColor:[UIColor whiteColor]];
        [self.backView setBackgroundColor:[UIColor colorWithRed:198/255.f green:185/255.f blue:173/255.f alpha:1.0f]];
    }
    else
    {
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [self.backView setBackgroundColor:[UIColor clearColor]];
    }
}

@end
