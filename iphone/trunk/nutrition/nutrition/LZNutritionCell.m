//
//  LZNutritionCell.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutritionCell.h"
@implementation LZNutritionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)adjustLabelAccordingToProgress:(float)progress forLabelWidth:(float)labelWith
{
    CGRect labelFrame = self.supplyPercentlabel.frame;
    labelFrame.size.width = labelWith*progress < 30 ? 30:labelWith*progress;
    self.supplyPercentlabel.frame = labelFrame;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
