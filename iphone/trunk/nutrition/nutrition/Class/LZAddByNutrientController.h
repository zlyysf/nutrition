//
//  LZAddByNutrientController.h
//  nutrition
//
//  Created by liu miao on 6/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZNutrientFoodAddCell.h"
@interface LZAddByNutrientController : UIViewController<UITableViewDataSource,UITableViewDelegate,LZFoodCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSArray *foodArray;
//@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong,nonatomic)NSDictionary *foodStandardDict;
@property (assign, nonatomic)UITextField *currentFoodInputTextField;
@property (strong, nonatomic)NSString *nutrientTitle;
@property (strong, nonatomic)NSMutableDictionary *tempIntakeDict;
@end
