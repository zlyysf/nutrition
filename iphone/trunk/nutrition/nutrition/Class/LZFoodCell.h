//
//  LZFoodCell.h
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LZFoodCellDelegate<NSObject>
- (void)textFieldDidReturnForIndex:(NSIndexPath*)index andText:(NSString*)foodNumber;
@end
@interface LZFoodCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic)id<LZFoodCellDelegate>delegate;
@property (strong,nonatomic)NSIndexPath*cellIndexPath;
@property (strong, nonatomic) IBOutlet UITextField *intakeAmountTextField;

@end
