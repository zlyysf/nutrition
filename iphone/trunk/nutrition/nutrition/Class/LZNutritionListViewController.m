//
//  LZNutritionListViewController.m
//  nutrition
//
//  Created by liu miao on 8/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutritionListViewController.h"
#import "LZRecommendFood.h"
#import "LZRichNutritionViewController.h"
#import "LZConstants.h"
#import "MobClick.h"
#import "GADMasterViewController.h"
@interface LZNutritionListViewController ()
@property (assign,nonatomic)BOOL isFirstLoad;
@end

@implementation LZNutritionListViewController
@synthesize nutritionArray,isFirstLoad,admobView;
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
    self.title = @"营养元素";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    nutritionArray = [LZRecommendFood getCustomNutrients:nil];
    isFirstLoad = YES;
    int totalFloor = [nutritionArray count]/3+ (([nutritionArray count]%3 == 0)?0:1);
    float scrollHeight = totalFloor *94 + 20+ (totalFloor-1)*8+50;
    self.admobView = [[UIView alloc]initWithFrame:CGRectMake(0, scrollHeight-50, 320, 50)];
    [self.listView addSubview:self.admobView];
    [self.listView setContentSize:CGSizeMake(320, scrollHeight)];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:UmengPathYingYangYuanSu];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        [self setButtons];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathYingYangYuanSu];
}
-(void)setButtons
{
    float startY = 10;
    int floor = 1;
    int perRowCount = 3;
    float startX;
    for (int i=0; i< [self.nutritionArray count]; i++)
    {
        
        if (i>=floor *perRowCount)
        {
            floor+=1;
        }
        startX = 10+(i-(floor-1)*perRowCount)*102;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*102, 94, 94)];
        [self.listView addSubview:button];
        NSString *nutritionId = [self.nutritionArray objectAtIndex:i];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_button.png",nutritionId]] forState:UIControlStateNormal];
        button.tag = i+100;
        [button addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)typeButtonTapped:(UIButton *)sender
{
    int tag = sender.tag -100;
    NSDictionary *emptyIntake = [[NSDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:emptyIntake forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *nutritionId = [self.nutritionArray objectAtIndex:tag];
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *dict = [da getNutrientInfo:nutritionId];
    //NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
    NSString *nutritionName = [dict objectForKey:@"NutrientCnCaption"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZRichNutritionViewController *addByNutrientController = [storyboard instantiateViewControllerWithIdentifier:@"LZRichNutritionViewController"];
    addByNutrientController.nutrientDict = dict;
    addByNutrientController.nutrientTitle = nutritionName;
    [self.navigationController pushViewController:addByNutrientController animated:YES];

}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.nutritionArray count];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LZNutritionListCell * cell =(LZNutritionListCell*)[tableView dequeueReusableCellWithIdentifier:@"LZNutritionListCell"];
//    NSString *nutritionId = [self.nutritionArray objectAtIndex:indexPath.row];
//    LZDataAccess *da = [LZDataAccess singleton];
//    NSDictionary *dict = [da getNutrientInfo:nutritionId];
//    NSString *nutritionName = [dict objectForKey:@"NutrientCnCaption"];
//    cell.nutritionNameLabel.text = nutritionName;
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 15;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    return sectionView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    return sectionView;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary *emptyIntake = [[NSDictionary alloc]init];
//    [[NSUserDefaults standardUserDefaults] setObject:emptyIntake forKey:LZUserDailyIntakeKey];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    NSString *nutritionId = [self.nutritionArray objectAtIndex:indexPath.row];
//    LZDataAccess *da = [LZDataAccess singleton];
//    NSDictionary *dict = [da getNutrientInfo:nutritionId];
//    //NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
//    NSString *nutritionName = [dict objectForKey:@"NutrientCnCaption"];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    LZRichNutritionViewController *addByNutrientController = [storyboard instantiateViewControllerWithIdentifier:@"LZRichNutritionViewController"];
//    addByNutrientController.nutrientDict = dict;
//    addByNutrientController.nutrientTitle = nutritionName;
//    [self.navigationController pushViewController:addByNutrientController animated:YES];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [self setListView:nil];
    [super viewDidUnload];
}
@end
