//
//  LZFoodCell.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZEditFoodAmountButton.h"
#import "LZKeyboardToolBar.h"
@protocol LZRecommendFoodCellDelegate<NSObject>
- (void)textFieldDidReturnForId:(NSString*)foodId andText:(NSString*)foodNumber;
- (void)textFieldDidBeginEditingForId:(NSString *)foodId textField:(UITextField*)currentTextField;
@end

@interface LZRecommendFoodCell : UITableViewCell<UITextFieldDelegate,LZKeyboardToolBarDelegate>
@property (weak, nonatomic)id<LZRecommendFoodCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) NSString * cellFoodId;
@property (strong, nonatomic) IBOutlet UILabel *foodUnitLabel;
@property (strong, nonatomic) IBOutlet UIImageView *recommendSignImageView;
@property (strong, nonatomic) IBOutlet UITextField *foodAmountTextField;
@property (strong, nonatomic) IBOutlet UIImageView *textBackImage;

@end
