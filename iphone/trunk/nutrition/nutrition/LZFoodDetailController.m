//
//  LZFoodDetailController.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodDetailController.h"
#define kProgressBarRect CGRectMake(2,2,220,16)
#import "LZNutritionSupplyCell.h"
#import "LZStandardContentCell.h"
@interface LZFoodDetailController ()

@end

@implementation LZFoodDetailController

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
    self.title = @"黄豆";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        LZNutritionSupplyCell *cell = (LZNutritionSupplyCell *)[tableView dequeueReusableCellWithIdentifier:@"LZNutritionSupplyCell"];
//        UIView *tempView = [[UIView alloc] init];
//        [cell setBackgroundView:tempView];
//        [cell setBackgroundColor:[UIColor clearColor]];

        [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:[UIColor greenColor] progress:0.5 withRadius:8];
        return cell;
    }
    else
    {
        LZStandardContentCell *cell = (LZStandardContentCell *)[tableView dequeueReusableCellWithIdentifier:@"LZStandardContentCell"];
        if (indexPath.row == 0)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_top@2x" ofType:@"png"];
            UIImage * cellTopImage = [UIImage imageWithContentsOfFile:path];

            [cell.cellBackgroundImageView setImage:cellTopImage];
        }
        else if (indexPath.row == 2)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_bottomp@2x" ofType:@"png"];
            UIImage * cellBottomImage = [UIImage imageWithContentsOfFile:path];
            [cell.cellBackgroundImageView setImage:cellBottomImage];
        }
        else
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_middle@2x" ofType:@"png"];
            UIImage * cellMiddleImage = [UIImage imageWithContentsOfFile:path];
            [cell.cellBackgroundImageView setImage:cellMiddleImage];
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 84;
    else
        return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}// Default is 1 if not implemented

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"供给比例=供给量/标准需求量";
    else
        return @"标准含量(100g)";
}// fixed font style. use custom

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
