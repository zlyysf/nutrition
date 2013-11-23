//
//  NGHealthReportViewController.m
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGHealthReportViewController.h"

@interface NGHealthReportViewController ()
@property (nonatomic,assign)BOOL isFirstLoad;
@end

@implementation NGHealthReportViewController
@synthesize lackNutritionArray,potentialArray,attentionArray,isFirstLoad;
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
    [self.mainScrollView setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    isFirstLoad = YES;
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        [self displayReport];
    }
}
-(void)displayReport
{
    [self.mainScrollView setContentSize:CGSizeMake(320, 800)];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
