//
//  LZTimeSettingsViewController.h
//  nutrition
//
//  Created by liu miao on 9/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZTimeSettingsViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *shangwuTextField;
@property (strong, nonatomic) IBOutlet UISwitch *reminderStateSwitch;
@property (strong, nonatomic) IBOutlet UITextField *xiawuTextField;
@property (strong, nonatomic) IBOutlet UITextField *shuiqianTextField;
@property (strong, nonatomic) IBOutlet UIView *line1View;
@property (strong, nonatomic) IBOutlet UIView *line2View;
@property (strong, nonatomic) IBOutlet UIView *line3View;
@property (strong, nonatomic) IBOutlet UIImageView *outBoundImageView;

@end
