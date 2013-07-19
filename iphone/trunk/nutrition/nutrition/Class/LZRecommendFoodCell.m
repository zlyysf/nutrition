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
    }
    else
    {
        [self.foodNameLabel setTextColor:[UIColor blackColor]];
        [self.foodWeightlabel setTextColor:[UIColor blackColor]];
        [self.foodUnitLabel setTextColor:[UIColor blackColor]];
        [self.foodTotalUnitLabel setTextColor:[UIColor darkGrayColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
    }
}
@end
