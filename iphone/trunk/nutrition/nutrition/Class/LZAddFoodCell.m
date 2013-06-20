//
//  LZAddFoodCell.m
//  nutrition
//
//  Created by liu miao on 6/20/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZAddFoodCell.h"

@implementation LZAddFoodCell

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
        [self.foodTypeNameLabel setTextColor:[UIColor whiteColor]];
        //[self.foodWeightlabel setTextColor:[UIColor whiteColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelectedBack.png"]]];
    }
    else
    {
        [self.foodTypeNameLabel setTextColor:[UIColor blackColor]];
        //[self.foodWeightlabel setTextColor:[UIColor blackColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
    }
}

@end
