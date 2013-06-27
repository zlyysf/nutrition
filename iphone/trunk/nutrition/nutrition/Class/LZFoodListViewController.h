//
//  LZFoodListViewController.h
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZFoodListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSMutableArray *takenFoodArray;
@property (strong, nonatomic)NSMutableDictionary *takenFoodDict;
@property (strong,nonatomic)NSMutableArray *nutrientInfoArray;
@property (assign,nonatomic)BOOL needRefresh;
@end
