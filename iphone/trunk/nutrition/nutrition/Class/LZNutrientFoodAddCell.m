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
    CGRect buttonFrame = self.foodNameButton.frame;
    
    if (centered)
    {
        buttonFrame.origin.y = 13;
    }
    else
    {
        buttonFrame.origin.y = 4;
    }
    
    self.foodNameButton.frame = buttonFrame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
