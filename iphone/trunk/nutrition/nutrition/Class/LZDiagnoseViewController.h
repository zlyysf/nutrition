//
//  LZDiagnoseViewController.h
//  nutrition
//
//  Created by liu miao on 8/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
@interface LZDiagnoseViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIScrollView *outScrollView;
@property (strong, nonatomic) IBOutlet UITableView *listView1;
@property (strong, nonatomic) IBOutlet UITableView *listView2;
@property (strong, nonatomic) IBOutlet UITableView *listView3;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet SMPageControl *smPageControl;
@property (strong, nonatomic) IBOutlet UIImageView *list1BG;
@property (strong, nonatomic) IBOutlet UIImageView *list2BG;
@property (strong, nonatomic) IBOutlet UIImageView *list3BG;
@property (strong, nonatomic) IBOutlet UIImageView *list4BG;
@property (strong,nonatomic)NSArray *list1DataSourceArray;
@property (strong,nonatomic)NSArray *list2DataSourceArray;
@property (strong,nonatomic)NSArray *list3DataSourceArray;
@property (strong,nonatomic)NSMutableArray *list1CheckStateArray;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong,nonatomic)NSMutableArray *list2CheckStateArray;
@property (strong, nonatomic) IBOutlet UIView *resultView;
@property (strong, nonatomic) IBOutlet UIButton *recommendFoodButton;
@property (strong,nonatomic)NSMutableArray *list3CheckStateArray;
@property (strong, nonatomic) IBOutlet UILabel *question1Label;
@property (strong, nonatomic) IBOutlet UILabel *question2Label;
@property (strong, nonatomic) IBOutlet UILabel *question3Label;
@property (strong, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;
@property (strong,nonatomic)NSArray *orderedNutrientsInSet;
@property (strong, nonatomic) IBOutlet UILabel *nutrientTipLabel;
@property (assign,nonatomic)float displayAreaHeight;
@property (assign,nonatomic)int maxNutrientCount;
@end
