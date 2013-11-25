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
            fontSize = 14;
        }
        else
        {
            fontSize = 12;
        }
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5f;
        // Initialization code
        self.alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        [self.alphaView setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f]];
        [self addSubview:alphaView];
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        [self.typeLabel setTextColor:[UIColor whiteColor]];
        [self.typeLabel setFont:[UIFont systemFontOfSize:fontSize]];
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
