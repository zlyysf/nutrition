//
//  LZFoodNutritionCell.m
//  nutrition
//
//  Created by liu miao on 6/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodNutritionCell.h"
#import "LZNutrientionManager.h"
#import "LZConstants.h"
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
        [self.backView setBackgroundColor:[UIColor colorWithRed:198/255.f green:185/255.f blue:173/255.f alpha:1.0f]];
        //[self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelectedBack.png"]]];
        [self.nutritionNameButton setUserInteractionEnabled:NO];
        [self.addFoodButton setUserInteractionEnabled:NO];
        //[self.cellArrowImage setImage:[UIImage imageNamed:@"arrow_click.png"]];
    }
    else
    {
        [self.supplyPercentlabel setTextColor:[UIColor blackColor]];
        [self.nutritionNameButton setUserInteractionEnabled:YES];
        [self.addFoodButton setUserInteractionEnabled:YES];
        [self.backView setBackgroundColor:[UIColor clearColor]];
        //[self.cellArrowImage setImage:[UIImage imageNamed:@"arrow.png"]];
    }
}
- (IBAction)nameButtonTapped:(id)sender {
    //[[NSNotificationCenter defaultCenter]postNotificationName:Notification_ShowNutrientInfoKey object:nil];
    [[LZNutrientionManager SharedInstance]showNutrientInfo:self.nutrientId];
}

@end
