//
//  NGHealthReportViewController.h
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGHealthReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *lackNutritionArray;
@property (strong, nonatomic) NSArray *potentialArray;
@property (strong, nonatomic) NSArray *attentionArray;
@property (strong, nonatomic) NSArray *recommendFoodArray;
@end
