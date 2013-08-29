//
//  LZFoodSearchViewController.m
//  nutrition
//
//  Created by liu miao on 8/29/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodSearchViewController.h"

@interface LZFoodSearchViewController ()

@end

@implementation LZFoodSearchViewController

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
    self.title = @"食物查询";
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
    UISearchBar *searchBar = self.searchResultVC.searchBar;
    UIView *barBack = [searchBar.subviews objectAtIndex:0];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"nav_bar@2x" ofType:@"png"];
    UIImage * navImage = [UIImage imageWithContentsOfFile:path];
    UIImage *gradientImage44 = [navImage
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:gradientImage44];
    [barBack addSubview: bgImage];

	// Do any additional setup after loading the view.
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
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:NO];
    return YES;

}

- (void)viewDidUnload {
    [self setListView:nil];
    [self setSearchResultVC:nil];
    [super viewDidUnload];
}
@end
