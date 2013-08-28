//
//  LZDiseaseResultViewController.m
//  nutrition
//
//  Created by liu miao on 8/28/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDiseaseResultViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface LZDiseaseResultViewController ()

@end

@implementation LZDiseaseResultViewController
@synthesize relatedNutritionArray;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"  返回" forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 48, 30);
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = cancelItem;
    NSString *list_bg_path = [[NSBundle mainBundle] pathForResource:@"table_list_bg@2x" ofType:@"png"];
    UIImage * list_bg_image = [UIImage imageWithContentsOfFile:list_bg_path];
    UIImage *list_bg = [list_bg_image resizableImageWithCapInsets:UIEdgeInsetsMake(20,10,20,10)];
    [self.backImageView setImage:list_bg];
    [self.resultView.layer setMasksToBounds:YES];
    [self.resultView.layer setCornerRadius:5];
    [self.resultView setBackgroundColor:[UIColor clearColor]];
}
-(void)cancelButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDiseaseInfoLabel:nil];
    [self setNutrientLabel:nil];
    [self setRecommendFoodButton:nil];
    [self setBackImageView:nil];
    [self setResultView:nil];
    [super viewDidUnload];
}
@end
