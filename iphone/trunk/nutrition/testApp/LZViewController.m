//
//  LZViewController.m
//  testApp
//
//  Created by Yasofon on 13-5-3.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZViewController.h"

#import "LZTest1.h"


@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnRunTestPressed:(id)sender {
    [LZTest1 test1];
    //    [LZTest1 test2];
    //    [LZTest1 test3];
    //    [LZTest1 test4];
//    [LZTest1 testRecommendFoodBySmallIncrement];
}


@end
