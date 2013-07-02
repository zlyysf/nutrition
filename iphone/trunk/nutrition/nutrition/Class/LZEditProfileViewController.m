//
//  LZEditProfileViewController.m
//  nutrition
//
//  Created by liu miao on 7/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZEditProfileViewController.h"

@interface LZEditProfileViewController ()

@end

@implementation LZEditProfileViewController

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
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    self.title = @"编辑个人资料";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cancelButtonTapped
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)saveButtonTapped
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
