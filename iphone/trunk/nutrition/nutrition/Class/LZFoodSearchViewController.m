//
//  LZFoodSearchViewController.m
//  nutrition
//
//  Created by liu miao on 8/29/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodSearchViewController.h"
#import "LZDataAccess.h"
#import "LZFoodTypeButton.h"
#import "LZDailyIntakeViewController.h"
@interface LZFoodSearchViewController ()
{
    BOOL isfirstLoad;
}
@end

@implementation LZFoodSearchViewController
@synthesize allFood,foodNameArray,foodTypeArray;
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
    isfirstLoad = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
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
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_bg.png"]];
    [barBack addSubview:bgImage];
    
    allFood = [[LZDataAccess singleton]getAllFood];
    NSMutableSet *foodTypeSet = [NSMutableSet set];
    self.foodTypeArray = [[NSMutableArray alloc]init];
    self.foodNameArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< [allFood count]; i++)
    {
        NSDictionary *afood = [allFood objectAtIndex:i];
        NSString *foodType = [afood objectForKey:@"CnType"];
        if (![foodTypeSet containsObject:foodType])
        {
            NSMutableArray *foodName = [[NSMutableArray alloc]init];
            [foodName addObject:afood];
            [self.foodNameArray addObject:foodName];
            [self.foodTypeArray addObject:foodType];
            [foodTypeSet addObject:foodType];
        }
        else
        {
            int index = [self.foodTypeArray indexOfObject:foodType];
            [[self.foodNameArray objectAtIndex:index]addObject:afood];
        }
    }

	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (isfirstLoad)
    {
        isfirstLoad = NO;
        [self setButtons];
    }
}
-(void)setButtons
{
    float startY = 54;
    int floor = 1;
    int perRowCount = 3;
    float startX1 = 10;
    float startX2 = 113;
    float startX3 = 216;
    float startX;
    for (int i=0; i< [self.foodTypeArray count]; i++)
    {
        if (i%perRowCount ==0)
        {
            startX = startX1;
        }
        else if(i%perRowCount ==1)
        {
            startX = startX2;
        }
        else
        {
            startX = startX3;
        }
        if (i>=floor *perRowCount)
        {
            floor+=1;
        }
        NSString *typeName = [self.foodTypeArray objectAtIndex:i];
        LZFoodTypeButton *button = [[LZFoodTypeButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*62, 94, 52)];
        [self.view addSubview:button];
        button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
        button.tag = i+100;
        [button addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textAlignment = UITextAlignmentLeft;
        //[button.titleLabel setBackgroundColor:[UIColor blackColor]];
        [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [button setTitle:typeName forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"type_button_normal.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"type_button_clicked.png"] forState:UIControlStateHighlighted];
        float titleLength = button.titleLabel.frame.size.width;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 34, 0, 94-34-titleLength)];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
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
-(void)typeButtonTapped:(UIButton *)sender
{
    int tag = sender.tag -100;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZDailyIntakeViewController *dailyIntakeViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDailyIntakeViewController"];
    dailyIntakeViewController.foodArray = [self.foodNameArray objectAtIndex:tag];
    //dailyIntakeViewController.foodIntakeDictionary = self.foodIntakeDictionary;
    dailyIntakeViewController.titleString = [self.foodTypeArray objectAtIndex:tag];
    [self.navigationController pushViewController:dailyIntakeViewController animated:YES];
}
- (void)viewDidUnload {
    [self setSearchResultVC:nil];
    [super viewDidUnload];
}
@end
