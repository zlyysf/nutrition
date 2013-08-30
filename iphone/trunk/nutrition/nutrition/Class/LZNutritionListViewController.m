//
//  LZNutritionListViewController.m
//  nutrition
//
//  Created by liu miao on 8/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutritionListViewController.h"
#import "LZNutritionListCell.h"
#import "LZRecommendFood.h"
@interface LZNutritionListViewController ()

@end

@implementation LZNutritionListViewController
@synthesize nutritionArray;
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
    NSLog(@"%@",nutritionArray);
    
	// Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nutritionArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZNutritionListCell * cell =(LZNutritionListCell*)[tableView dequeueReusableCellWithIdentifier:@"LZNutritionListCell"];
    NSString *nutritionId = [self.nutritionArray objectAtIndex:indexPath.row];
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *dict = [da getNutrientInfo:nutritionId];
    NSString *nutritionName = [dict objectForKey:@"NutrientCnCaption"];
    [cell.nutritionNameButton setTitle:nutritionName forState:UIControlStateNormal];
    cell.nutritionId = nutritionId;
    
    return cell;
}
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
@end
