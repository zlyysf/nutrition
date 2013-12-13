//
//  NGReportNutritonFoodCell.m
//  nutrition
//
//  Created by liu miao on 12/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGReportNutritonFoodCell.h"
#define RecommendFoodMargin 14
#define RecommendScrollViewHeight 120
#import "NGRecommendFoodView.h"
#import "LZUtility.h"
#import "LZConstants.h"
@implementation NGReportNutritonFoodCell
@synthesize cellIndex,delegate;
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
-(void)setFoods:(NSArray*)foodArray isChinese:(BOOL)isChinese
{
//    for (UIView * subv in self.foodScrollView.subviews)
//    {
//        [subv removeFromSuperview];
//    }
    BOOL isFirstLoad = YES;
    if ([self.foodScrollView.subviews count]!=0)
    {
        isFirstLoad = NO;
    }
    int foodCount =[foodArray count];
    [self.foodScrollView setContentSize:CGSizeMake(2+foodCount*(80+RecommendFoodMargin)-RecommendFoodMargin, RecommendScrollViewHeight)];
    for (int l=0; l< foodCount; l++)
    {
        NSDictionary *foodInfo = [foodArray objectAtIndex:l];
        NSString *picturePath;
        NSString *picPath = [foodInfo objectForKey:@"PicPath"];
        if (picPath == nil || [picPath isEqualToString:@""])
        {
            picturePath = [[NSBundle mainBundle]pathForResource:@"defaulFoodPic" ofType:@"png"];
        }
        else
        {
            NSString * picFolderPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"foodDealed"];
            picturePath = [picFolderPath stringByAppendingPathComponent:picPath];
        }
        NSString *foodQueryKey;
        if (isChinese)
        {
            foodQueryKey = @"CnCaption";
        }
        else
        {
            foodQueryKey = @"FoodNameEn";
        }
        NSString *foodName = [foodInfo objectForKey:foodQueryKey];
        
        NSNumber *weight = [foodInfo objectForKey:@"FoodAmount"];
        //cell.foodUnitLabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
        //NSDictionary *foodAtr = [allFoodUnitDict objectForKey:foodId];
        NSString *singleUnitName = [LZUtility getSingleItemUnitName:[foodInfo objectForKey:COLUMN_NAME_SingleItemUnitName]];
        NSString *foodTotalUnit = @"";
        if ([singleUnitName length]==0)
        {
            foodTotalUnit = [NSString stringWithFormat:@"%dg",[weight intValue]];
        }
        else
        {
            NSNumber *singleUnitWeight = [foodInfo objectForKey:COLUMN_NAME_SingleItemUnitWeight];
            int maxCount = (int)(ceilf(([weight floatValue]*2)/[singleUnitWeight floatValue]));
            //int unitCount = (int)((float)([weight floatValue]/[singleUnitWeight floatValue])+0.5);
            if (maxCount <= 0)
            {
                foodTotalUnit = [NSString stringWithFormat:@"%dg",[weight intValue]];
            }
            else
            {
                if (maxCount %2 == 0)
                {
                    foodTotalUnit = [NSString stringWithFormat:@"%d%@",(int)(maxCount*0.5f),singleUnitName];
                }
                else
                {
                    foodTotalUnit = [NSString stringWithFormat:@"%.1f%@",maxCount*0.5f,singleUnitName];
                }
                
            }
        }
        if (isFirstLoad)
        {
            NGRecommendFoodView *foodView = [[NGRecommendFoodView alloc]initWithFrame:CGRectMake(1+l*(80+RecommendFoodMargin), 0, 80, 120) foodName:foodName foodPic:picturePath foodAmount:foodTotalUnit];
            foodView.tag = 10+l;
            foodView.touchButton.tag = 10+l;
            [foodView.touchButton addTarget:self action:@selector(foodClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.foodScrollView addSubview:foodView];
        }
        else
        {
            //NSLog(@"%@",[self.foodScrollView.subviews description]);
            NGRecommendFoodView *foodView = (NGRecommendFoodView*)[self.foodScrollView viewWithTag:10+l];
            foodView.foodNameLabel.text = foodName;
            foodView.foodAmountLabel.text = foodTotalUnit;
            UIImage *foodImage = [UIImage imageWithContentsOfFile:picturePath];
            [foodView.foodImageView setImage:foodImage];
        }
        
    }
}
-(void)foodClicked:(UIButton*)sender
{
    //NGRecommendFoodView *view = (NGRecommendFoodView*)sender.view;
    int tag = sender.tag-10;
    if (self.delegate && [self.delegate respondsToSelector:@selector(foodClickedForIndex:andTag:)])
    {
        [self.delegate foodClickedForIndex:cellIndex andTag:tag];
    }
}
@end
