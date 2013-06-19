//
//  LZNutritionInfoView.m
//  rgbCalculator
//
//  Created by liu miao on 6/19/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutritionInfoView.h"
#import <QuartzCore/QuartzCore.h>
@implementation LZNutritionInfoView
@synthesize backView;
- (id)initWithFrame:(CGRect)frame
           andColor:(UIColor *)backColor
            andInfo:(NSDictionary *)infoDict
           delegate:(id<LZNutritionInfoViewDelegate>)nutrientDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backColor;
        self.delegate = nutrientDelegate;
        // Initialization code
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 330)];
        [backView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:backView];
        backView.center = self.center;
        
       UIView * descriptionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 304)];
        [descriptionView setBackgroundColor:[UIColor whiteColor]];
        descriptionView.layer.masksToBounds = YES;
        descriptionView.layer.cornerRadius = 10.f;
        descriptionView.layer.opacity = 1.0f;
         [backView addSubview:descriptionView];
        descriptionView.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2);
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonTyped:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setFrame:CGRectMake(0, 0, 30, 30)];
        //closeButton.center = CGPointMake(descriptionView.frame.origin.x + descriptionView.frame.size.width-10, descriptionView.frame.origin.y+10);
        closeButton.center = CGPointMake(descriptionView.frame.origin.x +descriptionView.frame.size.width-10, descriptionView.frame.origin.y+10);
        [backView addSubview: closeButton];
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, descriptionView.frame.size.width-4, descriptionView.frame.size.height-4)];
        textView.text = @"123";//[infoDict description];
        
        textView.editable = NO;
        textView.userInteractionEnabled = NO;
        [descriptionView addSubview:textView];
        textView.center = CGPointMake(descriptionView.frame.size.width/2,descriptionView.frame.size.height/2);
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
