//
//  LZAddFoodViewController.h
//  nutrition
//
//  Created by liu miao on 6/20/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZAddFoodViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic)NSMutableDictionary *foodIntakeDictionary;
@property (strong, nonatomic)NSMutableArray *foodTypeArray;
@property (strong, nonatomic)NSArray *allFood;
@property (strong , nonatomic)NSMutableArray *foodNameArray;
@end
