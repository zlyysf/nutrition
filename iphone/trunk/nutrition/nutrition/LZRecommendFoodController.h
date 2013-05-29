//
//  LZViewController.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LZRecommendFoodController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSMutableArray *recommendFoodArray;
@property (strong,nonatomic)NSMutableDictionary *recommendFoodDict;
@property (strong,nonatomic)NSMutableArray *nutrientInfoArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *changeOnePlanItem;
@property (assign, nonatomic)BOOL needResfesh;
@end
