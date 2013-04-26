//
//  LZDailyIntakeViewController.m
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDailyIntakeViewController.h"

@interface LZDailyIntakeViewController ()

@end

@implementation LZDailyIntakeViewController

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
	// Do any additional setup after loading the view.
}
- (IBAction)saveButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
