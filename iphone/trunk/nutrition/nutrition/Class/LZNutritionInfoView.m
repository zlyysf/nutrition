//
//  LZNutritionInfoView.m
//  rgbCalculator
//
//  Created by liu miao on 6/19/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutritionInfoView.h"

@implementation LZNutritionInfoView
//@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
           andColor:(UIColor *)backColor
           delegate:(id<LZNutritionInfoViewDelegate>)nutrientDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backColor;
        self.delegate = nutrientDelegate;
        // Initialization code
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonTyped:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview: closeButton];
    }
    return self;
}
- (void)closeButtonTyped:(id)sender
{
    //[self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoViewClosed:)])
    {
        [self.delegate infoViewClosed:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
