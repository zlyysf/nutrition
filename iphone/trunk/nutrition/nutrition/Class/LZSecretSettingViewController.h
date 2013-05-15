//
//  LZSecretSettingViewController.h
//  nutrition
//
//  Created by Yasofon on 13-5-15.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZSecretSettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *switchRandomSelectFood;

@property (weak, nonatomic) IBOutlet UITextField *textfieldRandomRangeSelectFood;

@property (weak, nonatomic) IBOutlet UISwitch *switchNeedLimitNutrients;

@property (weak, nonatomic) IBOutlet UITextField *textfieldLimitRecommendFoodCount;

@property (weak, nonatomic) IBOutlet UISwitch *switchNotAllowSameFood;

- (IBAction)onSaveClick:(id)sender;

@end
