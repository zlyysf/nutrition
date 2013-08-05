//
//  LZSettingsViewController.h
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdWall.h"
@interface LZSettingsViewController : UIViewController<UITextFieldDelegate,BaiduMobAdWallDelegate>
@property (strong, nonatomic) IBOutlet UIView *line2View;
@property (strong, nonatomic) IBOutlet UIView *line3View;
@property (strong, nonatomic) IBOutlet UIView *line4View;
@property (strong, nonatomic) IBOutlet UIView *line1View;
@property (strong, nonatomic) IBOutlet UIImageView *personsBackImageView;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic)UITextField * currentTextField;
@property (strong, nonatomic) IBOutlet UISwitch *weiboAuthSwitch;
@property (strong, nonatomic) IBOutlet UIView *admobView;
@property (strong, nonatomic) IBOutlet UIView *topSectionView;
@property (strong, nonatomic) IBOutlet UIView *midSectionView;
@property (strong, nonatomic) IBOutlet UIView *bottomSectionView;
@property (strong, nonatomic) IBOutlet UILabel *userSexLabel;
@property (strong, nonatomic) IBOutlet UILabel *userHeightLabel;
@property (strong, nonatomic) IBOutlet UILabel *userWeightLabel;
@property (strong, nonatomic) IBOutlet UILabel *userActivityLabel;
@property (strong, nonatomic) IBOutlet UILabel *userAgeLabel;
@property (nonatomic, strong) BaiduMobAdWall *baiduAdWall;
@end
