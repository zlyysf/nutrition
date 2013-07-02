//
//  LZDailyIntakeViewController.h
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDataAccess.h"
//#import "LZValueSelectorView.h"
@interface LZDailyIntakeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>//IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong , nonatomic)NSMutableArray *foodArray;
@property (strong, nonatomic)NSMutableDictionary *foodIntakeDictionary;
//@property (strong, nonatomic)NSMutableArray *foodTypeArray;
//@property (strong, nonatomic)NSArray *allFood;
@property (strong,nonatomic)NSString *titleString;

//@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIView *admobView;
@property (assign, nonatomic)UITextField *currentFoodInputTextField;
//@property (strong, nonatomic)IBOutlet LZValueSelectorView *selectorView;
//@property (assign,nonatomic)int currentSelectedIndex;
@end
