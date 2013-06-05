//
//  LZFoodCell.h
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZKeyboardToolBar.h"
@protocol LZFoodCellDelegate<NSObject>
- (void)textFieldDidReturnForIndex:(NSIndexPath*)index andText:(NSString*)foodNumber;
- (void)textFieldDidBeginEditingForIndex:(NSIndexPath*)index textField:(UITextField*)currentTextField;
@end
@interface LZFoodCell : UITableViewCell<UITextFieldDelegate,LZKeyboardToolBarDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *foodPicView;
@property (strong, nonatomic) IBOutlet UIImageView *textFiledBackImage;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic)id<LZFoodCellDelegate>delegate;
@property (strong,nonatomic)NSIndexPath*cellIndexPath;
@property (strong, nonatomic) IBOutlet UITextField *intakeAmountTextField;
@property (strong, nonatomic) IBOutlet UIView *backView;

@end
