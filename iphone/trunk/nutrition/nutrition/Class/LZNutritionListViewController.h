//
//  LZNutritionListViewController.h
//  nutrition
//
//  Created by liu miao on 8/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZNutritionListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSArray *nutritionArray;
@end
