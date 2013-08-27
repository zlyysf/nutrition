//
//  LZFoodListViewController.h
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum listType
{
    dietListTypeNew = 0,
    dietListTypeOld = 1
}DietListType;
@interface LZDietListMakeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSMutableArray *takenFoodIdsArray;
@property (strong, nonatomic)NSMutableDictionary *takenFoodDict;
@property (strong,nonatomic)NSMutableArray *nutrientInfoArray;
@property (strong,nonatomic)NSMutableDictionary *takenFoodNutrientInfoDict;
@property (strong,nonatomic)NSMutableDictionary *recommendFoodDictForDisplay;
@property (strong,nonatomic)NSMutableDictionary *allFoodUnitDict;
@property (assign, nonatomic)DietListType listType;
@property (assign,nonatomic)BOOL needRefresh;
@property (strong,nonatomic)NSNumber *dietId;
@property (nonatomic,assign)BOOL backWithNoAnimation;
@property (nonatomic,assign)BOOL useRecommendNutrient;
@end
