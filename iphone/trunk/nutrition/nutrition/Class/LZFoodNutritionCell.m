//
//  LZFoodNutritionCell.m
//  nutrition
//
//  Created by liu miao on 6/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodNutritionCell.h"

@implementation LZFoodNutritionCell

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
-(void)adjustLabelAccordingToProgress:(float)progress forLabelWidth:(float)labelWith
{
    CGRect labelFrame = self.supplyPercentlabel.frame;
    labelFrame.size.width = labelWith*progress < 30 ? 30:labelWith*progress;
    self.supplyPercentlabel.frame = labelFrame;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted)
    {
        [self.supplyPercentlabel setTextColor:[UIColor whiteColor]];
        [self.nutritionNameLabel setTextColor:[UIColor whiteColor]];
        //[self setBackgroundColor:[UIColor greenColor]];
    }
    else
    {
        [self.supplyPercentlabel setTextColor:[UIColor blackColor]];
        [self.nutritionNameLabel setTextColor:[UIColor blackColor]];
        //[self setBackgroundColor:[UIColor clearColor]];
    }
}

@end
