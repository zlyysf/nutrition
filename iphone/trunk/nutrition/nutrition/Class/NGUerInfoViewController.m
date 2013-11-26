//
//  NGUerInfoViewController.m
//  nutrition
//
//  Created by liu miao on 11/25/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGUerInfoViewController.h"

@interface NGUerInfoViewController ()

@end

@implementation NGUerInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    [self.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.backView.layer setBorderWidth:0.5f];
    [self.headerLabel.layer setBorderWidth:0.5f];
    [self.headerLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.headerLabel.text = @"  基本信息";
    self.birthdayLabel.text = @"生日";
    self.heightLabel.text = @"身高";
    self.sexLabel.text = @"性别";
    self.activityLabel.text = @"活动强度";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
