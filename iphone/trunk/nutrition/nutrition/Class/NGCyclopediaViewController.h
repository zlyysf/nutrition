//
//  NGCyclopediaViewController.h
//  nutrition
//
//  Created by liu miao on 11/25/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGCyclopediaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSArray *commonDiseaseArray;
@property (strong,nonatomic)NSArray *nutritionArray;
@property (strong,nonatomic)NSArray *foodArray;
@property (strong,nonatomic)NSArray *nutritionVitaminArray;
@property (strong,nonatomic)NSArray *nutritionMineralArray;
@property (strong,nonatomic)NSArray *nutritionOtherArray;
@end
