//
//  LZFoodNutritionCell.m
//  nutrition
//
//  Created by liu miao on 6/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodNutritionCell.h"
#import "LZNutrientionManager.h"
@implementation LZFoodNutritionCell
@synthesize nutrientId;
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
        //[self.nutritionNameButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.cellArrowImage setImage:[UIImage imageNamed:@"arrow_click.png"]];
    }
    else
    {
        [self.supplyPercentlabel setTextColor:[UIColor blackColor]];
        //[self.nutritionNameButton.titleLabel setTextColor:[UIColor darkTextColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.cellArrowImage setImage:[UIImage imageNamed:@"arrow.png"]];
    }
}
- (IBAction)nameButtonTapped:(id)sender {
    [[LZNutrientionManager SharedInstance]showNutrientInfo:self.nutrientId];
}

@end
