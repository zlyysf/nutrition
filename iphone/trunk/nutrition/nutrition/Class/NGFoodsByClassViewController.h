//
//  NGFoodsByClassViewController.h
//  nutrition
//
//  Created by Yasofon on 14-2-10.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "NGFoodCombinationEditViewController.h"
#import "NGFoodDetailController.h"
#import "LZDataAccess.h"



@interface NGFoodsByClassViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>//,NGSelectFoodAmountDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong , nonatomic)NSArray *foodArray;
//@property (strong, nonatomic)NSMutableDictionary *foodIntakeDictionary;
//@property (strong, nonatomic)NSMutableArray *foodTypeArray;
//@property (strong, nonatomic)NSArray *allFood;
@property (strong,nonatomic)NSString *titleString;
//@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIView *admobView;
@property (assign,nonatomic)BOOL isFromOut;
//@property (strong, nonatomic)IBOutlet LZValueSelectorView *selectorView;
//@property (assign,nonatomic)int currentSelectedIndex;

@property (assign,nonatomic)id<NGFoodCombinationEditViewControllerDelegate> editDelegate;
//@property (assign,nonatomic) NGFoodCombinationEditViewController *editViewController;

@end
