//
//  LZSettingsViewController.h
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZSettingsViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *personsTextField;
@property (strong, nonatomic) IBOutlet UITextField *daysTextField;
@property (strong, nonatomic) IBOutlet UIImageView *personsBackImageView;
@property (strong, nonatomic) IBOutlet UIImageView *daysBackImageView;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic)UITextField * currentTextField;
@end
