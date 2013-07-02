//
//  LZEditProfileViewController.h
//  nutrition
//
//  Created by liu miao on 7/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZKeyboardToolBar.h"
@interface LZEditProfileViewController : UIViewController<UITextFieldDelegate,LZKeyboardToolBarDelegate>
@property (strong,nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) IBOutlet UIView *line4View;
@property (strong, nonatomic) IBOutlet UIView *line3View;
@property (strong, nonatomic) IBOutlet UIView *line2View;
@property (strong, nonatomic) IBOutlet UIView *line1View;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIButton *maleButton;
@property (strong, nonatomic) IBOutlet UIButton *femaleButton;
@property (strong, nonatomic) IBOutlet UIImageView *ageBackImageView;
@property (strong, nonatomic) IBOutlet UIImageView *heightBackImageView;
@property (strong, nonatomic) IBOutlet UIImageView *weightBackImageView;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextField *heightTextField;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UIButton *level0Button;
@property (strong, nonatomic) IBOutlet UIButton *level1Button;
@property (strong, nonatomic) IBOutlet UIButton *level2Button;
@property (strong, nonatomic) IBOutlet UIButton *level3Button;
@property (strong, nonatomic) IBOutlet UILabel *levelDescriptionLabel;
@property (nonatomic, readwrite) int currentSexSelection;
@property (nonatomic, readwrite) int currentActivityLevelSelection;
@end
