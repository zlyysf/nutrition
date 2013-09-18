//
//  LZTimeSettingsViewController.m
//  nutrition
//
//  Created by liu miao on 9/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZTimeSettingsViewController.h"

@interface LZTimeSettingsViewController ()

@end

@implementation LZTimeSettingsViewController

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
    self.title = @"诊断提醒";
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveItemTapped)];
    self.navigationItem.rightBarButtonItem = saveItem;

	// Do any additional setup after loading the view.
}
-(void)saveItemTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
