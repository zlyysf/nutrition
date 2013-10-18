//
//  LZFoodTypeButton.m
//  nutrition
//
//  Created by liu miao on 8/29/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodTypeButton.h"
#import "LZUtility.h"
@implementation LZFoodTypeButton
@synthesize alphaView,typeLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float fontSize;
        if ([LZUtility isCurrentLanguageChinese]) {
            fontSize = 18;
        }
        else
        {
            fontSize = 16;
        }
        // Initialization code
        self.alphaView = [[UIView alloc]initWithFrame:CGRectMake(1, frame.size.height-28-1, frame.size.width-2, 28)];
        [self.alphaView setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f]];
        [self addSubview:alphaView];
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, frame.size.height-28-1, frame.size.width-2, 28)];
        [self.typeLabel setTextColor:[UIColor whiteColor]];
        [self.typeLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
        [self.typeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.typeLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:typeLabel];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//}


@end
