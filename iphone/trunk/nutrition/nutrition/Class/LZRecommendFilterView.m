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
#import "LZConstants.h"
#import "LZUtility.h"
#define kSelectButtonSide 22.f
#define kButtonAreaSide 40.f
#define kTagAddNum 20
#define kNameButtonAddNum 100
#define kMaxFilterLine 7
@implementation LZRecommendFilterView
@synthesize backView,delegate,cancelButton,submitButton,filterArray,listView;
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
        CGSize tipsLabelSize = [title sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(270, 9999) lineBreakMode:UILineBreakModeWordWrap];
        float count = [self.filterArray count];
        int floor =(int)(ceilf(count/2.f));
        int totalFloor;
        if (floor >kMaxFilterLine)
        {
            totalFloor =kMaxFilterLine;
        }
        else
        {
            totalFloor = floor;
        }
        calculatedHeight = 10+tipsLabelSize.height+10+kSelectButtonSide+20+totalFloor*(kSelectButtonSide+20)+30+10;
        backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, calculatedHeight)];
        [backView setBackgroundColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.9]];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 10.f;
        backView.layer.opacity = 1.0f;
        [self addSubview:backView];
        backView.center = CGPointMake(self.center.x, self.center.y-20);
        float pointY = 10;
        float pointX = 20;
        
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
        CGPoint selectAllCenter = self.selectallButton.center;
        CGRect allselectFrame = self.selectallButton.frame;
        allselectFrame.size = CGSizeMake(kButtonAreaSide, kButtonAreaSide);
        self.selectallButton.frame = allselectFrame;
        self.selectallButton.center = selectAllCenter;
        //[self.selectallButton setBackgroundColor:[UIColor redColor]];
        [backView addSubview:self.selectallButton];
        
        
        UIButton *allselectButton = [[UIButton alloc]initWithFrame:CGRectMake(pointX+20+kSelectButtonSide, pointY, 80, kSelectButtonSide)];
        [allselectButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [allselectButton setTitle:NSLocalizedString(@"quanxuanbutton",@"全选") forState:UIControlStateNormal];
        [allselectButton setTitle:NSLocalizedString(@"quanxuanbutton",@"全选") forState:UIControlStateHighlighted];
        [allselectButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [allselectButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
        allselectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [allselectButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:allselectButton];
        
        pointY+= kSelectButtonSide+20;
        
        self.listView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, pointY, 300, totalFloor*(kSelectButtonSide+20)-20)];
        //[self.listView setBackgroundColor:[UIColor blueColor]];
        [self.listView setContentSize:CGSizeMake(300, floor*(kSelectButtonSide+20)-20+((kButtonAreaSide-kSelectButtonSide)*2))];
        [backView addSubview:listView];
        
        float newPointY =(kButtonAreaSide-kSelectButtonSide) -(kSelectButtonSide+20);
        LZDataAccess *da = [LZDataAccess singleton];
        for (int i=0; i<[self.filterArray count]; i++)
        {
            NSDictionary *nutrientState = [self.filterArray objectAtIndex:i];
            NSArray *keys = [nutrientState allKeys];
            NSString *key = [keys objectAtIndex:0];
            NSDictionary *dict = [da getNutrientInfo:key];
            NSString *queryKey;
            if ([LZUtility isCurrentLanguageChinese])
            {
                queryKey = @"NutrientCnCaption";
            }
            else
            {
                queryKey = @"NutrientEnCaption";
            }

            NSString *name = [dict objectForKey:queryKey];
            NSNumber *state = [nutrientState objectForKey:key];
            float buttonX;
            float labelX;
            if (i%2 == 0)
            {
                //换行
                newPointY+= kSelectButtonSide+20;
                buttonX = pointX;
                labelX = pointX+20+kSelectButtonSide;
                
            }
            else
            {
                buttonX = pointX+150;
                labelX = pointX+170+kSelectButtonSide;
            }
            UIButton *nutrientButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, newPointY, kSelectButtonSide, kSelectButtonSide)];
            nutrientButton.tag = i+kTagAddNum;
            CGPoint nutrientCenter = nutrientButton.center;
            CGRect nutrientFrame = nutrientButton.frame;
            nutrientFrame.size = CGSizeMake(kButtonAreaSide, kButtonAreaSide);
            nutrientButton.frame = allselectFrame;
            nutrientButton.center = nutrientCenter;
            [nutrientButton addTarget:self action:@selector(nutrientButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            //[nutrientButton setBackgroundColor:[UIColor redColor]];
            
            if ([state boolValue])
            {
                [nutrientButton setImage:[UIImage imageNamed:@"nutrient_button_on.png"] forState:UIControlStateNormal];
            }
            else
            {
                [nutrientButton setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];
            }
            
            [listView addSubview:nutrientButton];
            
            UIButton *nutrientNameButton = [[UIButton alloc]initWithFrame:CGRectMake(labelX, newPointY, 80, kSelectButtonSide)];
            [nutrientNameButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [nutrientNameButton setTitle:name forState:UIControlStateNormal];
            [nutrientNameButton setTitle:name forState:UIControlStateHighlighted];
            [nutrientNameButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [nutrientNameButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
            nutrientNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            nutrientNameButton.tag = i+kNameButtonAddNum;
            [nutrientNameButton addTarget:self action:@selector(nutrientNameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [listView addSubview:nutrientNameButton];
        }
        
        pointY += self.listView.frame.size.height+20;
        UIImage *button30 = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(50, pointY, 75, 30)];
        [self.cancelButton setTitle:NSLocalizedString(@"quxiaobutton",@"取消") forState:UIControlStateNormal];
        [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.cancelButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [self.cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton setBackgroundImage:button30 forState:UIControlStateNormal];
        [backView addSubview:self.cancelButton];
        
        self.submitButton = [[UIButton alloc]initWithFrame:CGRectMake(175, pointY, 75, 30)];
        [self.submitButton setTitle:NSLocalizedString(@"querenbutton",@"确认") forState:UIControlStateNormal];
        [self.submitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.submitButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.submitButton setBackgroundImage:button30 forState:UIControlStateNormal];
        [backView addSubview:self.submitButton];
        
        CGPoint listCenter = self.listView.center;
        CGRect listFrame = self.listView.frame;
        listFrame.size.height += ((kButtonAreaSide-kSelectButtonSide)*2);
        self.listView.frame = listFrame;
        self.listView.center = listCenter;
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
            UIButton *button = (UIButton *) [self.listView viewWithTag:i+kTagAddNum];
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
            UIButton *button = (UIButton *) [self.listView viewWithTag:i+kTagAddNum];
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
- (void)nutrientNameButtonTapped:(UIButton *)sender
{
    int tag = sender.tag-kNameButtonAddNum;
    NSDictionary *nutrientState = [self.filterArray objectAtIndex:tag];
    NSArray *keys = [nutrientState allKeys];
    NSString *key = [keys objectAtIndex:0];
    NSNumber *state = [nutrientState objectForKey:key];
    if ([state boolValue])
    {
        NSDictionary *newState = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:NO],key ,nil];
        [self.filterArray replaceObjectAtIndex:tag withObject:newState];
        UIButton *button = (UIButton *) [self.listView viewWithTag:tag+kTagAddNum];
        [button setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];
    }
    else
    {
        NSDictionary *newState = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],key ,nil];
        [self.filterArray replaceObjectAtIndex:tag withObject:newState];
        UIButton *button = (UIButton *) [self.listView viewWithTag:tag+kTagAddNum];
        [button setImage:[UIImage imageNamed:@"nutrient_button_on.png"] forState:UIControlStateNormal];
    }
    if (![self isAllSelected:self.filterArray])
    {
        [self.selectallButton setImage:[UIImage imageNamed:@"nutrient_button_off.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.selectallButton setImage:[UIImage imageNamed:@"nutrient_button_on.png"] forState:UIControlStateNormal];
    }

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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") message:NSLocalizedString(@"recommendfilter_alert0_message",@"请至少选择一个营养素") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(filterViewSubmitted:)])
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.filterArray forKey:KeyUserRecommendPreferNutrientArray];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.delegate filterViewSubmitted:self];
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
