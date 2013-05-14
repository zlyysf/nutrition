//
//  LZViewController.m
//  ImpExpTool
//
//  Created by Yasofon on 13-5-13.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZViewController.h"

#import "LZFacade.h"

@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [LZFacade test1];
    [LZFacade generateInitialData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
