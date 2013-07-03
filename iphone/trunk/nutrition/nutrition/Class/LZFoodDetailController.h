//
//  LZFoodDetailController.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZFoodDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSArray *nutrientSupplyArray;
@property (strong,nonatomic)NSArray *nutrientStandardArray;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (readwrite, nonatomic)BOOL isForRecomendFood;
@property (strong,nonatomic)NSString *foodName;
@end
