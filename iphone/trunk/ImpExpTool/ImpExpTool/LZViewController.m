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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTestClick:(id)sender {
    [LZFacade test1];
//    [LZFacade test2];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"run finish" message:@"run finish" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)btnInitDbClick:(id)sender {
    [LZFacade generateInitialData];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"run finish" message:@"run finish" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)btnGenAllDataClick:(id)sender {
    [LZFacade generateInitialDataToAllInOne];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"run finish" message:@"run finish" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)btnGenCsvClick:(id)sender {
    [LZFacade generateVariousCsv];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"run finish" message:@"run finish" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


@end
