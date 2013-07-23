//
//  LZDiteCell.m
//  nutrition
//
//  Created by liu miao on 7/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDiteCell.h"

@implementation LZDiteCell
@synthesize dietInfo;
#define KLabelPointX 82
#define KLabelSuperViewHeight 53
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
        [self.arrowImageView setImage:[UIImage imageNamed:@"big_arrow_clicked.png"]];
        //[self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelectedBack.png"]]];
        [self.backView setBackgroundColor:[UIColor colorWithRed:198/255.f green:185/255.f blue:173/255.f alpha:1.0f]];
    }
    else
    {
        [self.dietNameLabel setTextColor:[UIColor blackColor]];
        [self.arrowImageView setImage:[UIImage imageNamed:@"big_arrow.png"]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
    }
}
-(void)adjustLabelAccordingToDietName:(NSString *)dietName
{
    CGSize nameSize = [dietName sizeWithFont:[UIFont systemFontOfSize:20]constrainedToSize:CGSizeMake(195, 9999) lineBreakMode:UILineBreakModeWordWrap];
    NSString *onelineStr = @"1";
    CGSize onelineSize = [onelineStr sizeWithFont:[UIFont systemFontOfSize:20]constrainedToSize:CGSizeMake(195, 9999) lineBreakMode:UILineBreakModeWordWrap];
    float onelineHeight = onelineSize.height;
    float nameHeight = nameSize.height;
    if (nameHeight > onelineHeight)
    {
        self.dietNameLabel.frame = CGRectMake(KLabelPointX, (KLabelSuperViewHeight-onelineHeight*2)/2, 190, onelineHeight*2);
        
        self.dietNameLabel.lineBreakMode  = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
    }
    else
    {
        self.dietNameLabel.frame = CGRectMake(KLabelPointX, (KLabelSuperViewHeight-nameHeight)/2, 190, nameHeight);
        self.dietNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        
    }
    [self.dietNameLabel setFont:[UIFont systemFontOfSize:20]];
    self.dietNameLabel.text = dietName;
}
@end
