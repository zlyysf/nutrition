//
//  LZDietPickerViewController.m
//  nutrition
//
//  Created by liu miao on 8/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDietPickerViewController.h"
#import "LZDietPickerCell.h"
#import "LZDataAccess.h"
#import "LZDietListMakeViewController.h"
#import "LZUserDietListViewController.h"
#import "LZConstants.h"
#import "LZMainPageViewController.h"
#import "LZUtility.h"
@interface LZDietPickerViewController ()

@end

@implementation LZDietPickerViewController
@synthesize dietArray,foodDict;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    self.dietArray = [[NSMutableArray alloc]init];
    self.title = @"添加食物";
    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"  返回" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 48, 30);
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;

	// Do any additional setup after loading the view.
}
-(void)backButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self displayLocalDietList];
}
- (void)displayLocalDietList
{
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSArray *localDietArray = [da getAllFoodCollocation];
    [self.dietArray removeAllObjects];
    [self.dietArray addObjectsFromArray:localDietArray];
    [self.listView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
#pragma mark- TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return [self.dietArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LZDietPickerCell * cell =(LZDietPickerCell*)[tableView dequeueReusableCellWithIdentifier:@"LZDietPickerCell"];
    if (indexPath.section == 0)
    {
        [cell adjustLabelAccordingToDietName:@"添加到新清单"];
    }
    else
    {
        NSDictionary *aDiet = [self.dietArray objectAtIndex:indexPath.row];
        NSString *dietName = [aDiet objectForKey:@"CollocationName"];
        [cell adjustLabelAccordingToDietName:dietName];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 5;
    return 32;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
        [sectionView setBackgroundColor:[UIColor clearColor]];
        return sectionView;
    }
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 32)];
    UIImageView *sectionBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
    [sectionView addSubview:sectionBarView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"section_bar@2x" ofType:@"png"];
    UIImage * sectionBarImage = [UIImage imageWithContentsOfFile:path];
    [sectionBarView setImage:sectionBarImage];
    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 27)];
    [sectionTitleLabel setTextColor:[UIColor whiteColor]];
    [sectionTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:sectionTitleLabel];
    sectionTitleLabel.text =  @"添加到已有的膳食清单";
    
    return sectionView;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZUserDietListViewController *userDietListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZUserDietListViewController"];
    userDietListViewController.backWithNoAnimation = YES;
    LZMainPageViewController *mainPageViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZMainPageViewController"];
    [LZUtility initializePreferNutrient];
//    NSArray *preferNutrient = [[NSUserDefaults standardUserDefaults]objectForKey:KeyUserRecommendPreferNutrientArray];
//    NSSet *selectNutrient = [NSSet setWithArray:self.recommendNutritionArray];
//    NSMutableArray *newPreferArray = [[NSMutableArray alloc]init];
//    for (NSDictionary *aNutrient in preferNutrient)
//    {
//        NSString *nId = [[aNutrient allKeys]objectAtIndex:0];
//        if ([selectNutrient containsObject:nId])
//        {
//            NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],nId, nil];
//            [newPreferArray addObject:newDict];
//        }
//        else
//        {
//            NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],nId, nil];
//            [newPreferArray addObject:newDict];
//        }
//    }
//    [[NSUserDefaults standardUserDefaults]setObject:newPreferArray forKey:KeyUserRecommendPreferNutrientArray];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    if (indexPath.section == 0)
    {
        NSString *addFoodId = [[foodDict allKeys]objectAtIndex:0];
        NSNumber *addFoodAmount = [foodDict objectForKey:addFoodId];
        [LZUtility addFood:addFoodId withFoodAmount:addFoodAmount];
        LZDietListMakeViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietListMakeViewController"];
        foodListViewController.listType = dietListTypeNew;
        foodListViewController.backWithNoAnimation = YES;
        NSArray *vcs = [NSArray arrayWithObjects:mainPageViewController,userDietListViewController,foodListViewController, nil];
        UINavigationController *mainNav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [mainNav setViewControllers:vcs animated:YES];
    }
    else
    {
        LZDataAccess *da = [LZDataAccess singleton];
        NSDictionary *aDiet = [self.dietArray objectAtIndex:indexPath.row];
        NSNumber *dietId = [aDiet objectForKey:@"CollocationId"];
        NSArray *array = [da getCollocationFoodData_withCollocationId:dietId];
        NSLog(@"%@",array);
        NSMutableDictionary *dietContentDict = [[NSMutableDictionary alloc]init];
        for (NSDictionary *aFood in array)
        {
            NSNumber* foodAmount = [aFood objectForKey:@"FoodAmount"];
            NSString* foodId = [aFood objectForKey:@"FoodId"];
            
            //[dietContentDict setObject:foodAmount forKey:[LZUtility convertNumberToFoodIdStr:foodId]];
            [dietContentDict setObject:foodAmount forKey:foodId];
        }
        NSString *dietTitle =  [aDiet objectForKey:@"CollocationName"];
        NSDictionary *temp = [[NSDictionary alloc]initWithDictionary:dietContentDict];
        [[NSUserDefaults standardUserDefaults]setObject:temp forKey:LZUserDailyIntakeKey];
        [[NSUserDefaults  standardUserDefaults]synchronize];
        NSString *addFoodId = [[foodDict allKeys]objectAtIndex:0];
        NSNumber *addFoodAmount = [foodDict objectForKey:addFoodId];
        [LZUtility addFood:addFoodId withFoodAmount:addFoodAmount];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LZDietListMakeViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietListMakeViewController"];
        foodListViewController.listType = dietListTypeOld;
        foodListViewController.title = dietTitle;
        foodListViewController.dietId = dietId;
        foodListViewController.backWithNoAnimation = YES;
        NSArray *vcs = [NSArray arrayWithObjects:mainPageViewController,userDietListViewController,foodListViewController, nil];
        UINavigationController *mainNav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [mainNav setViewControllers:vcs animated:YES];
    }
}

@end
