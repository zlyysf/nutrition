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
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        [backView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:backView];
        backView.center = CGPointMake(self.center.x, self.center.y-20);
        
       UIView * descriptionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, frame.size.height-20)];
        [descriptionView setBackgroundColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.9]];
        descriptionView.layer.masksToBounds = YES;
        descriptionView.layer.cornerRadius = 10.f;
        descriptionView.layer.opacity = 1.0f;
         [backView addSubview:descriptionView];
        descriptionView.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2);
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_button_highlight.png"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(closeButtonTyped:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setFrame:CGRectMake(0, 0, 30, 30)];
        //closeButton.center = CGPointMake(descriptionView.frame.origin.x + descriptionView.frame.size.width-10, descriptionView.frame.origin.y+10);
        closeButton.center = CGPointMake(descriptionView.frame.origin.x +descriptionView.frame.size.width-10, descriptionView.frame.origin.y+10);
        [backView addSubview: closeButton];
        
        UILabel * nutrientNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 260, 25)];
        [nutrientNameLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [nutrientNameLabel setBackgroundColor:[UIColor clearColor]];
        [nutrientNameLabel setTextColor:[UIColor blackColor]];
        nutrientNameLabel.text = [infoDict objectForKey:@"NutrientCnCaption"];
        [descriptionView addSubview:nutrientNameLabel];
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 38,280, frame.size.height-65)];
        [textView setFont:[UIFont systemFontOfSize:14]];
//        NSString *contents = @"";
//        for (NSString * key in [infoDict allKeys])
//        {
//            NSString *content = [infoDict objectForKey:key];
//            contents = [contents stringByAppendingFormat:@" %@ : %@ \n",key,content];
//        }
        textView.text =[infoDict objectForKey:@"NutrientDescription"];// [NSString stringWithFormat:@"%@",infoDict];//[infoDict description];
        textView.showsVerticalScrollIndicator = YES;
        [textView setBackgroundColor:[UIColor clearColor]];
        textView.editable = NO;
        [descriptionView addSubview:textView];
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
