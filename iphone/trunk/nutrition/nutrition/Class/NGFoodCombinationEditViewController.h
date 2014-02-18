//
//  NGFoodCombinationEditViewController.h
//  nutrition
//
//  Created by Yasofon on 14-2-7.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LZDietListMakeViewController.h"

//typedef enum listType
//{
//    dietListTypeNew = 0,
//    dietListTypeOld = 1
//}DietListType;

@protocol NGFoodCombinationEditViewControllerDelegate<NSObject>
    -(void)addToCombinationWithFoodId:(NSString *)foodId andAmount:(NSNumber*)amount;
    -(void)changeToCombinationWithFoodId:(NSString *)foodId andAmount:(NSNumber*)amount;
    -(NSDictionary*)getFoodAmountDict;
@end


@interface NGFoodCombinationEditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NGFoodCombinationEditViewControllerDelegate>
  @property (strong, nonatomic) IBOutlet UITableView *listView;
  @property (strong, nonatomic) IBOutlet UIButton *addFoodButton;
  @property (strong, nonatomic) IBOutlet UIButton *recommendFoodButton;
  @property (strong, nonatomic) IBOutlet UIButton *shareButton;
  @property (weak, nonatomic) IBOutlet UIImageView *ButtonsBackGroundImageView;


  @property (strong,nonatomic)NSNumber *dietId;



//@property (assign, nonatomic)DietListType listType;
//
//
  @property (nonatomic,assign)BOOL backWithNoAnimation;
//
//@property (nonatomic,assign)BOOL useRecommendNutrient;



@end
