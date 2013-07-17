//
//  LZEditFoodAmountButton.m
//  nutrition
//
//  Created by liu miao on 7/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZEditFoodAmountButton.h"

@implementation LZEditFoodAmountButton
@synthesize foodId;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage *textImage = [UIImage imageNamed:@"setting_text_back.png"];
    UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    [self setBackgroundImage:textBackImage forState:UIControlStateNormal];
    [self setBackgroundImage:textBackImage forState:UIControlStateHighlighted];
    
}


@end
