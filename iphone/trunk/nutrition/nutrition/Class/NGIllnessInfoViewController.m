//
//  NGIllnessInfoViewController.m
//  nutrition
//
//  Created by liu miao on 12/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGIllnessInfoViewController.h"

@interface NGIllnessInfoViewController ()

@end

@implementation NGIllnessInfoViewController
@synthesize illnessURL;
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
-(void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:self.illnessURL];
    NSURLRequest *contentRequest = [NSURLRequest requestWithURL:url];
    [self.contentWebView loadRequest:contentRequest];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
