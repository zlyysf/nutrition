//
//  LZNutritionListCell.m
//  nutrition
//
//  Created by liu miao on 8/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutritionListCell.h"

@implementation LZNutritionListCell
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
        [self.arrowImage setImage:[UIImage imageNamed:@"big_arrow_clicked.png"]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelectedBack.png"]]];
        [self.nutritionNameLabel setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [self.arrowImage setImage:[UIImage imageNamed:@"big_arrow.png"]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
        [self.nutritionNameLabel setTextColor:[UIColor blackColor]];
        
    }
}

@end
