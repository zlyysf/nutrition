//
//  LZCheckResultViewController.m
//  nutrition
//
//  Created by liu miao on 9/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZCheckResultViewController.h"

@interface LZCheckResultViewController ()
@end

@implementation LZCheckResultViewController
@synthesize userPreferArray,userSelectedNames;
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
    self.title = @"诊断结果";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:LZUserDailyIntakeKey];
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

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
@end
