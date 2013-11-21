//
//  NGDiagnosesView.m
//  nutrition
//
//  Created by liu miao on 11/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGDiagnosesView.h"

@implementation NGDiagnosesView
@synthesize cellIndex,selectColor,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(float)displayForFont:(UIFont *)font maxWidth:(float)maxWidth horizonPadding:(float)horizonPadding verticalPadding:(float)verticalPadding imageMargin:(float)imageMargin bottomMargin:(float)bottomMargin textArray:(NSArray *)textArray selectedColor:(UIColor *)selectedColor;
{
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    self.selectColor = selectedColor;
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in textArray) {
        CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
        textSize.width += horizonPadding*2;
        textSize.height += verticalPadding*2;
        UILabel *label = nil;
        if (!gotPreviousFrame) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            //labelFrame =CGRectMake(0, 0, textSize.width, textSize.height);
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + imageMargin > maxWidth) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + previousFrame.size.height + bottomMargin);
                totalHeight += textSize.height + bottomMargin;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + imageMargin, previousFrame.origin.y);
            }
            newRect.size = textSize;
            label = [[UILabel alloc] initWithFrame:newRect];
        }
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setFont:font];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTappedDiagnose:)];
        [label addGestureRecognizer:tap];
        label.numberOfLines = 0;
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        [label setText:text];
        [label setTextAlignment:UITextAlignmentCenter];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:3];
        [label.layer setBorderColor:[UIColor grayColor].CGColor];
        [label.layer setBorderWidth: 0.5f];

        [self addSubview:label];
    }
    return totalHeight;
}
-(void)userTappedDiagnose:(UITapGestureRecognizer*)sender
{
    UILabel *label = (UILabel *)sender.view;
    [label setBackgroundColor:self.selectColor];
    if (self.delegate && [self.delegate respondsToSelector:@selector(userSelectedItem:forIndexPath:)])
    {
        [self.delegate userSelectedItem:label.text forIndexPath:self.cellIndex];
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
