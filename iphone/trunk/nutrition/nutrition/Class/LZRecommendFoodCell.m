//
//  LZFoodCell.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFoodCell.h"

@implementation LZRecommendFoodCell
@synthesize cellFoodId;
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
        [self.foodNameLabel setTextColor:[UIColor whiteColor]];
        [self.foodWeightlabel setTextColor:[UIColor whiteColor]];
        [self.foodUnitLabel setTextColor:[UIColor whiteColor]];
        [self.foodTotalUnitLabel setTextColor:[UIColor whiteColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelectedBack.png"]]];
        UIImage *textImage = [UIImage imageNamed:@"setting_text_back.png"];
        UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        [self.editFoodButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.editFoodButton setBackgroundImage:textBackImage forState:UIControlStateHighlighted];
    }
    else
    {
        [self.foodNameLabel setTextColor:[UIColor blackColor]];
        [self.foodWeightlabel setTextColor:[UIColor blackColor]];
        [self.foodUnitLabel setTextColor:[UIColor blackColor]];
        [self.foodTotalUnitLabel setTextColor:[UIColor darkGrayColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
        UIImage *textImage = [UIImage imageNamed:@"setting_text_back.png"];
        UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        [self.editFoodButton setBackgroundImage:textBackImage forState:UIControlStateNormal];
        [self.editFoodButton setBackgroundImage:textBackImage forState:UIControlStateHighlighted];

    }
}
@end
