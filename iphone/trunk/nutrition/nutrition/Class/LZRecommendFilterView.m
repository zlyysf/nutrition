//
//  LZRecommendFilterView.m
//  nutrition
//
//  Created by liu miao on 7/16/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFilterView.h"
#import <QuartzCore/QuartzCore.h>
#import "LZDataAccess.h"
#define kSelectButtonSide 22.f
#define kTagAddNum 20
@implementation LZRecommendFilterView
@synthesize backView,delegate,cancelButton,submitButton,filterArray;
- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor*)backColor
         filterInfo:(NSArray*)filterInfo
            tipsStr:(NSString *)title
           delegate:(id<LZRecommendFilterViewDelegate>)filterDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = backColor;
        self.delegate = filterDelegate;
        self.filterArray = [[NSMutableArray alloc]initWithArray:filterInfo];
        float calculatedHeight = 0;
        CGSize tipsLabelSize = [title sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap];
        float count = [self.filterArray count];
        int floor =(int)(ceilf(count/2.f));
        calculatedHeight = 10+tipsLabelSize.height+10+kSelectButtonSide+20+floor*(kSelectButtonSide+20)+30+10;
        backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, calculatedHeight)];
        [backView setBackgroundColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.9]];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 10.f;
        backView.layer.opacity = 1.0f;
        [self addSubview:backView];
        backView.center = CGPointMake(self.center.x, self.center.y-20);
        float pointY = 10;
        float pointX = 10;
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointX, pointY, tipsLabelSize.width, tipsLabelSize.height)];
        [tipLabel setFont:[UIFont systemFontOfSize:15]];
        [tipLabel setBackgroundColor:[UIColor clearColor]];
        [tipLabel setTextColor:[UIColor blackColor]];
        tipLabel.numberOfLines = 0;
        tipLabel.lineBreakMode = UILineBreakModeWordWrap;
        tipLabel.text = title;
        [backView addSubview:tipLabel];
        pointY += tipsLabelSize.height+10;
        
        self.selectallButton = [[UIButton alloc]initWithFrame:CGRectMake(pointX, pointY, kSelectButtonSide, kSelectButtonSide)];
        [self.selectallButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        if ([self isAllSelected:self.filterArray])
        {
            [self.selectallButton setImage:[UIImage imageNamed:@"nutrient_button_on.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self.selectallButton setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];
        }
        [backView addSubview:self.selectallButton];
        
        UILabel *selectAllLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointX+20+kSelectButtonSide, pointY, 100, kSelectButtonSide)];
        [selectAllLabel setFont:[UIFont systemFontOfSize:15]];
        [selectAllLabel setBackgroundColor:[UIColor clearColor]];
        [selectAllLabel setTextColor:[UIColor blackColor]];
        selectAllLabel.text = @"全选";
        [backView addSubview:selectAllLabel];
        
        LZDataAccess *da = [LZDataAccess singleton];
        for (int i=0; i<[self.filterArray count]; i++)
        {
            NSDictionary *nutrientState = [self.filterArray objectAtIndex:i];
            NSArray *keys = [nutrientState allKeys];
            NSString *key = [keys objectAtIndex:0];
            NSDictionary *dict = [da getNutrientInfo:key];
            NSString *name = [dict objectForKey:@"NutrientCnCaption"];
            NSNumber *state = [nutrientState objectForKey:key];
            float buttonX;
            float labelX;
            if (i%2 == 0)
            {
                pointY+= kSelectButtonSide+20;//换行
                buttonX = pointX;
                labelX = pointX+20+kSelectButtonSide;
                
            }
            else
            {
                buttonX = pointX+150;
                labelX = pointX+170+kSelectButtonSide;
            }
            UIButton *nutrientButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, pointY, kSelectButtonSide, kSelectButtonSide)];
            nutrientButton.tag = i+kTagAddNum;
            [nutrientButton addTarget:self action:@selector(nutrientButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([state boolValue])
            {
                [nutrientButton setImage:[UIImage imageNamed:@"nutrient_button_on.png"] forState:UIControlStateNormal];
            }
            else
            {
                [nutrientButton setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];
            }
            
            [backView addSubview:nutrientButton];
            
            UILabel *nutrientNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, pointY, 100, kSelectButtonSide)];
            [nutrientNameLabel setFont:[UIFont systemFontOfSize:15]];
            [nutrientNameLabel setBackgroundColor:[UIColor clearColor]];
            [nutrientNameLabel setTextColor:[UIColor blackColor]];
            nutrientNameLabel.text = name;
            [backView addSubview:nutrientNameLabel];

        }
        
        pointY += kSelectButtonSide+20;
        UIImage *button30 = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(50, pointY, 75, 30)];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton setBackgroundImage:button30 forState:UIControlStateNormal];
        [backView addSubview:self.cancelButton];
        
        self.submitButton = [[UIButton alloc]initWithFrame:CGRectMake(175, pointY, 75, 30)];
        [self.submitButton setTitle:@"确认" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.submitButton setBackgroundImage:button30 forState:UIControlStateNormal];
        [backView addSubview:self.submitButton];
    }
    return self;
}
- (void)selectButtonTapped:(UIButton *)sender
{
    if ([self isAllSelected:self.filterArray])
    {
        [self unselectAllNutrient];
            
    }
    else
    {
        [self selectAllNutrient];
    }
}
- (void)unselectAllNutrient
{
    for(int i=0;i< [self.filterArray count];i++)
    {
        NSDictionary *nutrientState = [self.filterArray objectAtIndex:i];
        NSArray *keys = [nutrientState allKeys];
        NSString *key = [keys objectAtIndex:0];
        NSNumber *state = [nutrientState objectForKey:key];
        if ([state boolValue])
        {
            NSDictionary *newState = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:NO],key ,nil];
            [self.filterArray replaceObjectAtIndex:i withObject:newState];
            UIButton *button = (UIButton *) [self.backView viewWithTag:i+kTagAddNum];
            [button setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];
        }
    }
    [self.selectallButton setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];

}
- (void)selectAllNutrient
{
    for(int i=0;i< [self.filterArray count];i++)
    {
        NSDictionary *nutrientState = [self.filterArray objectAtIndex:i];
        NSArray *keys = [nutrientState allKeys];
        NSString *key = [keys objectAtIndex:0];
        NSNumber *state = [nutrientState objectForKey:key];
        if (![state boolValue])
        {
            NSDictionary *newState = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],key ,nil];
            [self.filterArray replaceObjectAtIndex:i withObject:newState];
            UIButton *button = (UIButton *) [self.backView viewWithTag:i+kTagAddNum];
            [button setImage:[UIImage imageNamed:@"nutrient_button_on.png"] forState:UIControlStateNormal];
        }
    }
    [self.selectallButton setImage:[UIImage imageNamed:@"nutrient_button_on.png"] forState:UIControlStateNormal];
}
- (void)nutrientButtonTapped:(UIButton *)sender
{
    int tag = sender.tag-kTagAddNum;
    NSDictionary *nutrientState = [self.filterArray objectAtIndex:tag];
    NSArray *keys = [nutrientState allKeys];
    NSString *key = [keys objectAtIndex:0];
    NSNumber *state = [nutrientState objectForKey:key];
    if ([state boolValue])
    {
        NSDictionary *newState = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:NO],key ,nil];
        [self.filterArray replaceObjectAtIndex:tag withObject:newState];
        [sender setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];
    }
    else
    {
        NSDictionary *newState = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],key ,nil];
        [self.filterArray replaceObjectAtIndex:tag withObject:newState];
        [sender setImage:[UIImage imageNamed:@"nutrient_button_on.png"] forState:UIControlStateNormal];
    }
    if (![self isAllSelected:self.filterArray])
    {
        [self.selectallButton setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.selectallButton setImage:[UIImage imageNamed:@"nutrient_button_on.png"] forState:UIControlStateNormal];
    }
//    else if ([self isAllUnSelected:self.filterArray])
//    {
//        [self.selectallButton setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];
//    }
}
- (void)cancelButtonTapped
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewCanceled:)])
    {
        [self.delegate filterViewCanceled:self];
    }
}
- (void)submitButtonTapped
{
    if ([self isAllUnSelected:self.filterArray])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请至少选择一个营养素" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(filterViewSubmitted:forFilterInfo:)])
    {
        [self.delegate filterViewSubmitted:self forFilterInfo:self.filterArray];
    }
}
-(BOOL)isAllSelected:(NSArray *)array
{
    BOOL allSelected = YES;
    for (NSDictionary *nutrientState in array)
    {
        NSArray *keys = [nutrientState allKeys];
        NSString *key = [keys objectAtIndex:0];
        NSNumber *state = [nutrientState objectForKey:key];
        if (![state boolValue])
        {
            allSelected = NO;
            break;
        }
    }
    return allSelected;
}
- (BOOL)isAllUnSelected:(NSArray *)array
{
    BOOL allUnSelected = YES;
    for (NSDictionary *nutrientState in array)
    {
        NSArray *keys = [nutrientState allKeys];
        NSString *key = [keys objectAtIndex:0];
        NSNumber *state = [nutrientState objectForKey:key];
        if ([state boolValue])
        {
            allUnSelected = NO;
            break;
        }
    }
    return allUnSelected;
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
