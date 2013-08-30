//
//  LZFoodDetailController.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZValueSelectorView.h"
#import "LZRecommendFood.h"
@protocol LZFoodDetailViewControllerDelegate<NSObject>
-(void)didChangeFoodId:(NSString *)foodId toAmount:(NSNumber*)changedValue;
@end
@interface LZFoodDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource,IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSArray *nutrientSupplyArray;
@property (strong,nonatomic)NSArray *nutrientStandardArray;
@property (strong,nonatomic)NSString *foodName;
@property (strong, nonatomic) IBOutlet LZValueSelectorView *foodValuePicker;
@property (strong, nonatomic) IBOutlet UILabel *foodAmountDisplayLabel;
@property (strong, nonatomic) IBOutlet UIButton *GUnitButton;
@property (strong, nonatomic) IBOutlet UIButton *UnitButton;
@property (assign,nonatomic)BOOL UseUnitDisplay;
@property (strong,nonatomic)IBOutlet UILabel *sectionLabel;
@property (assign,nonatomic)BOOL isUnitDisplayAvailable;
@property (strong,nonatomic)NSNumber *gUnitMaxValue;
@property (strong,nonatomic)NSNumber *unitMaxValue;
@property (strong,nonatomic)NSNumber *currentSelectValue;
@property (strong,nonatomic)NSNumber *defaulSelectValue;
@property (assign,nonatomic)BOOL isDefaultUnitDisplay;
@property (strong,nonatomic)NSString *unitName;
@property (strong,nonatomic)NSDictionary *foodAttr;
@property (strong,nonatomic)NSMutableDictionary *inOutParam;
@property (assign,nonatomic)id<LZFoodDetailViewControllerDelegate> delegate;
@property (assign,nonatomic)BOOL isCalForAll;
@property (strong,nonatomic)NSMutableDictionary *staticFoodAmountDict;
@property (assign,nonatomic)int GUnitStartIndex;
@property (assign,nonatomic)BOOL isForEdit;
@property (assign,nonatomic)BOOL isPushToDietPicker;
@end
