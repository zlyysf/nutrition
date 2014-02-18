//
//  NGFoodsByNutrientViewController.h
//  nutrition
//
//  Created by Yasofon on 14-2-7.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGFoodCombinationEditViewController.h"
#import "NGFoodDetailController.h"

@interface NGFoodsByNutrientViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>// ,NGSelectFoodAmountDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;

//@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic)NSString *NutrientId;
@property (strong, nonatomic)NSNumber *NutrientAmount;


@property (assign,nonatomic)id<NGFoodCombinationEditViewControllerDelegate> editDelegate;

@end
