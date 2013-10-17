//
//  LZCheckResultViewController.h
//  nutrition
//
//  Created by liu miao on 9/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZCheckResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *userPreferArray;
@property (nonatomic,strong)NSArray *heavylyLackArray;
@property (nonatomic,strong)NSArray *lightlyLackArray;
@property (nonatomic,strong)NSString *userSelectedNames;
@property (nonatomic,strong)NSMutableArray *nutritionNameArray;
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSMutableDictionary *recommendFoodDictForDisplay;
@property (strong,nonatomic)NSMutableArray *takenFoodIdsArray;
@property (strong, nonatomic)NSMutableDictionary *takenFoodDict;
@property (strong,nonatomic)NSMutableArray *nutrientInfoArray;
@property (strong,nonatomic)NSMutableDictionary *takenFoodNutrientInfoDict;
@property (strong,nonatomic)NSMutableDictionary *allFoodUnitDict;
@property (assign,nonatomic)int userTotalScore;

@end
