//
//  LZNutritionListViewController.h
//  nutrition
//
//  Created by liu miao on 8/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZNutritionListViewController : UIViewController

@property (strong,nonatomic)NSArray *nutritionArray;
@property (strong, nonatomic) IBOutlet UIScrollView *listView;
@property (strong,nonatomic)UIView *admobView;
@property (strong,nonatomic)NSDictionary *allNutritionDict;
@end
