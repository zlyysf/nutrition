//
//  NGFoodDetailController.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZSliderByScrollView.h"
#import "LZRecommendFood.h"
#import "NGFoodCombinationEditViewController.h"

//@protocol NGSelectFoodAmountDelegate<NSObject>
//    -(void)didChangeFoodId:(NSString *)foodId toAmount:(NSNumber*)changedValue;
//@end

@interface NGFoodDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource,LZSliderByScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) IBOutlet UILabel *foodAmountDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *LabelWeightUnit;

@property (strong, nonatomic) IBOutlet UIButton *GUnitButton;
@property (strong, nonatomic) IBOutlet UIButton *UnitButton;
@property (strong,nonatomic)IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet LZSliderByScrollView *RuleSlider;


@property (strong,nonatomic)NSString *FoodId;
@property (strong,nonatomic)NSDictionary *FoodAttr;
@property (strong,nonatomic)NSNumber *FoodAmount;//currentSelectValue

@property (assign,nonatomic) UIViewController *BackToViewControllerWhenFinish;
@property (assign,nonatomic)id<NGFoodCombinationEditViewControllerDelegate> editDelegate;
//@property (assign,nonatomic)id<NGSelectFoodAmountDelegate> delegate;

@property (assign,nonatomic)BOOL isForEdit;//false means add, true means edit
@property (assign,nonatomic)BOOL isCalForAll;// is calculated with all foods
@property (assign,nonatomic)BOOL notNeedSave;// similiar to readonly, but can change just in ui
@property (strong,nonatomic)NSDictionary *staticFoodAmountDict;





//@property (assign,nonatomic)BOOL UseUnitDisplay;
//
//@property (assign,nonatomic)BOOL isUnitDisplayAvailable;
//@property (strong,nonatomic)NSNumber *gUnitMaxValue;
//@property (strong,nonatomic)NSNumber *unitMaxValue;
//
//@property (strong,nonatomic)NSNumber *defaulSelectValue;
//@property (assign,nonatomic)BOOL isDefaultUnitDisplay;
//@property (strong,nonatomic)NSString *unitName;


//@property (assign,nonatomic)int GUnitStartIndex;
//
//@property (assign,nonatomic)BOOL isPushToDietPicker;




@end
