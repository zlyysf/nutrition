//
//  LZSettingsViewController.h
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZSettingsViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *line2View;

@property (strong, nonatomic) IBOutlet UIView *line1View;
@property (strong, nonatomic) IBOutlet UITextField *personsTextField;
@property (strong, nonatomic) IBOutlet UITextField *daysTextField;
@property (strong, nonatomic) IBOutlet UIImageView *personsBackImageView;
@property (strong, nonatomic) IBOutlet UIImageView *daysBackImageView;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic)UITextField * currentTextField;
@property (strong, nonatomic) IBOutlet UISwitch *weiboAuthSwitch;
@property (strong, nonatomic) IBOutlet UIView *admobView;
@property (strong, nonatomic) IBOutlet UIView *topSectionView;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIView *midSectionView;
@property (strong, nonatomic) IBOutlet UIView *bottomSectionView;
@end
