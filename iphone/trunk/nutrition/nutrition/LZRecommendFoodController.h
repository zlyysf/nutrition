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
@property (strong,nonatomic)NSArray *recommendFoodArray;
@property (strong,nonatomic)NSDictionary *recommendFoodDict;
@property (strong,nonatomic)NSArray *nutrientInfoArray;
@end
