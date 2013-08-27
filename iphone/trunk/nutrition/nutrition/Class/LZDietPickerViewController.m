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
@interface LZDietPickerViewController ()

@end

@implementation LZDietPickerViewController
@synthesize dietArray;
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
	// Do any additional setup after loading the view.
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
        [cell adjustLabelAccordingToDietName:@"新建列表"];
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
    sectionTitleLabel.text =  @"推荐到已有的膳食清单";
    
    return sectionView;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZUserDietListViewController *uerDietListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZUserDietListViewController"];
    
    if (indexPath.section == 0)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        LZDietListMakeViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietListMakeViewController"];
        foodListViewController.listType = dietListTypeNew;
        NSArray *vcs = [NSArray arrayWithObjects:uerDietListViewController,foodListViewController, nil];
        [self.navigationController setViewControllers:vcs animated:YES];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LZDietListMakeViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietListMakeViewController"];
        foodListViewController.listType = dietListTypeOld;
        foodListViewController.title = dietTitle;
        foodListViewController.dietId = dietId;
        NSArray *vcs = [NSArray arrayWithObjects:uerDietListViewController,foodListViewController, nil];
        [self.navigationController setViewControllers:vcs animated:YES];
    }
}

@end
