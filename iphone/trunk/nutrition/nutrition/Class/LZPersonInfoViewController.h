//
//  LZPersonInfoViewController.h
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZPersonInfoViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextField *heightTextField;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *activityLevelSegmentControl;
@property (strong, nonatomic) IBOutlet UILabel *activityLevelBriefLabel;

@end
