//
//  LZNutrientFoodAddCell.m
//  nutrition
//
//  Created by liu miao on 6/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutrientFoodAddCell.h"

@implementation LZNutrientFoodAddCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)centeredFoodNameButton:(BOOL)centered
{
    CGRect buttonFrame = self.foodNameLabel.frame;
    
    if (centered)
    {
        buttonFrame.origin.y = 15;
    }
    else
    {
        buttonFrame.origin.y = 7;
    }
    
    self.foodNameLabel.frame = buttonFrame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted)
    {
        [self.recommendAmountLabel setTextColor:[UIColor whiteColor]];
        
    }
    else
    {
        [self.recommendAmountLabel setTextColor:[UIColor darkGrayColor]];
        
    }
}

@end
