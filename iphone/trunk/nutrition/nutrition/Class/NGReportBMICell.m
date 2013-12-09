//
//  NGReportBMICell.m
//  nutrition
//
//  Created by liu miao on 12/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGReportBMICell.h"
#define LevelHighlightColor [UIColor blackColor]
#define LevelNormalColor [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0f]
@implementation NGReportBMICell

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

-(void)setBMIValue:(double)bmiValue
{
    if (bmiValue<18.5)
    {
        [self.level1Label setTextColor:LevelHighlightColor];
        [self.level1Label setBackgroundColor:[UIColor colorWithRed:263/255.f green:232/255.f blue:81/255.f alpha:1.0f]];
//        [self.level2Label setTextColor:LevelNormalColor];
//        [self.level3Label setTextColor:LevelNormalColor];
//        [self.level4Label setTextColor:LevelNormalColor];
    }
    else if (bmiValue>=18.5 && bmiValue<25)
    {
//        [self.level1Label setTextColor:LevelNormalColor];
        [self.level2Label setTextColor:LevelHighlightColor];
        [self.level2Label setBackgroundColor:[UIColor colorWithRed:140/255.f green:215/255.f blue:121/255.f alpha:1.0f]];
//        [self.level3Label setTextColor:LevelNormalColor];
//        [self.level4Label setTextColor:LevelNormalColor];
    }
    else if (bmiValue >= 25 && bmiValue <30)
    {
//        [self.level1Label setTextColor:LevelNormalColor];
//        [self.level2Label setTextColor:LevelHighlightColor];
        [self.level3Label setTextColor:LevelNormalColor];
        [self.level3Label setBackgroundColor:[UIColor colorWithRed:263/255.f green:232/255.f blue:81/255.f alpha:1.0f]];
//        [self.level4Label setTextColor:LevelNormalColor];
    }
    else
    {
//        [self.level1Label setTextColor:LevelHighlightColor];
//        [self.level2Label setTextColor:LevelNormalColor];
//        [self.level3Label setTextColor:LevelNormalColor];
        [self.level4Label setTextColor:LevelNormalColor];
        [self.level4Label setBackgroundColor:[UIColor colorWithRed:227/255.f green:103/255.f blue:110/255.f alpha:1.0f]];
    }
}
@end
