//
//  LZFoodDetailController.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZValueSelectorView.h"
@interface LZFoodDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource,IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSArray *nutrientSupplyArray;
@property (strong,nonatomic)NSArray *nutrientStandardArray;
@property (strong,nonatomic)NSString *foodName;
@property (strong,nonatomic)NSString *sectionTitle;
@property (strong, nonatomic) IBOutlet LZValueSelectorView *foodValuePicker;
@property (strong, nonatomic) IBOutlet UILabel *foodAmountDisplayLabel;
@property (strong, nonatomic) IBOutlet UIButton *GUnitButton;
@property (strong, nonatomic) IBOutlet UIButton *UnitButton;
@property (readwrite,nonatomic)BOOL UseUnitDisplay;
@property (strong,nonatomic)IBOutlet UILabel *sectionLabel;
@end
