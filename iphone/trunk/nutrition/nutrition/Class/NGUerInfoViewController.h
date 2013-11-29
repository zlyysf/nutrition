//
//  NGUerInfoViewController.h
//  nutrition
//
//  Created by liu miao on 11/25/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGUerInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *weightUnitLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *listView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (strong, nonatomic) IBOutlet UITextField *heightTextField;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong,nonatomic) UIDatePicker *birthdayPicker;
@property (strong,nonatomic) UIPickerView *heightPicker;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSegmentControll;
@property (strong, nonatomic) IBOutlet UISegmentedControl *activitySegmentControll;
@property (assign,nonatomic)BOOL isPresented;
- (IBAction)activityChanged:(id)sender;


@end
