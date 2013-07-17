//
//  LZDiteCell.m
//  nutrition
//
//  Created by liu miao on 7/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDiteCell.h"

@implementation LZDiteCell

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
    if (highlighted)
    {
        [self.dietNameLabel setTextColor:[UIColor whiteColor]];
        [self.arrowImageView setImage:[UIImage imageNamed:@"big_arrow_clicked.png"]];
        //[self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelectedBack.png"]]];
        [self.backView setBackgroundColor:[UIColor colorWithRed:198/255.f green:185/255.f blue:173/255.f alpha:1.0f]];
    }
    else
    {
        [self.dietNameLabel setTextColor:[UIColor blackColor]];
        [self.arrowImageView setImage:[UIImage imageNamed:@"big_arrow.png"]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
    }
}

@end
