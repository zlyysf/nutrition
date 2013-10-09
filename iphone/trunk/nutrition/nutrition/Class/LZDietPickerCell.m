//
//  LZDietPickerCell.m
//  nutrition
//
//  Created by liu miao on 8/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDietPickerCell.h"

@implementation LZDietPickerCell
#define KNameLabelPointX 10
#define KNameLabelSuperViewHeight 53
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
        [self.dietNameLabel setTextColor:[UIColor whiteColor]];
        
        //[self.backView setBackgroundColor:[UIColor colorWithRed:198/255.f green:185/255.f blue:173/255.f alpha:1.0f]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelectedBack.png"]]];
    }
    else
    {
        [self.dietNameLabel setTextColor:[UIColor blackColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dietCellBack.png"]]];
    }
}
-(void)adjustLabelAccordingToDietName:(NSString *)dietName
{
    float bigFontSize = 18;
    float smallFontSize = 16;
    float labelWidth = 280;
    CGSize nameSize = [dietName sizeWithFont:[UIFont systemFontOfSize:bigFontSize]constrainedToSize:CGSizeMake(labelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
    NSString *onelineStr = @"1";
    CGSize onelineSize = [onelineStr sizeWithFont:[UIFont systemFontOfSize:bigFontSize]constrainedToSize:CGSizeMake(labelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
    float onelineHeight = onelineSize.height;
    float nameHeight = nameSize.height;
    if (nameHeight > onelineHeight)
    {
        CGSize nameSmallSize = [dietName sizeWithFont:[UIFont systemFontOfSize:smallFontSize]constrainedToSize:CGSizeMake(labelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
        CGSize onelineSmallSize = [onelineStr sizeWithFont:[UIFont systemFontOfSize:smallFontSize]constrainedToSize:CGSizeMake(labelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
        float onelineSmallHeight = onelineSmallSize.height;
        float nameSmallHeight = nameSmallSize.height;
        if (nameSmallHeight > onelineSmallHeight)
        {
            self.dietNameLabel.frame = CGRectMake(KNameLabelPointX, (KNameLabelSuperViewHeight-onelineSmallHeight*2)/2, labelWidth, onelineSmallHeight*2);
            self.dietNameLabel.lineBreakMode  = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
        }
        else
        {
            self.dietNameLabel.frame = CGRectMake(KNameLabelPointX, (KNameLabelSuperViewHeight-nameSmallHeight)/2, labelWidth, nameSmallHeight);
            self.dietNameLabel.lineBreakMode  = UILineBreakModeWordWrap;
        }
        [self.dietNameLabel setFont:[UIFont systemFontOfSize:smallFontSize]];
    }
    else
    {
        self.dietNameLabel.frame = CGRectMake(KNameLabelPointX, (KNameLabelSuperViewHeight-nameHeight)/2, labelWidth, nameHeight);
        self.dietNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self.dietNameLabel setFont:[UIFont systemFontOfSize:bigFontSize]];
    }
    
    self.dietNameLabel.text = dietName;
}

@end
