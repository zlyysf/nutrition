//
//  NGSingleFoodViewController.h
//  nutrition
//
//  Created by liu miao on 12/9/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGSingleFoodViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSDictionary *foodInfoDict;
@property (strong, nonatomic) IBOutlet UIView *weightSelectView;
@property (strong, nonatomic) IBOutlet UILabel *topHeaderLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *unitSegmentControl;
@property (strong, nonatomic) IBOutlet UILabel *weightDisplayLabel;
@property (strong, nonatomic) IBOutlet UIStepper *weightChangeStepper;
@property (strong, nonatomic) IBOutlet UILabel *underHeaderLabel;
@property (strong, nonatomic) IBOutlet UITableView *nutritionListView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong,nonatomic)NSArray *nutrientSupplyArray;
@property (strong,nonatomic)NSMutableDictionary *inOutParam;
@end
