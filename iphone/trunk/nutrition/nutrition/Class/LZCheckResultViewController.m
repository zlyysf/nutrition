//
//  LZCheckResultViewController.m
//  nutrition
//
//  Created by liu miao on 9/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZCheckResultViewController.h"
#import "LZEmptyClassCell.h"
#import "LZUtility.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "LZNutrientionManager.h"
@interface LZCheckResultViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (assign,nonatomic)float diseaseCellHeight;
@property (assign,nonatomic)float nutritionCellHeight;
@property (assign,nonatomic)BOOL isFirstLoad;
@end

@implementation LZCheckResultViewController
@synthesize userPreferArray,userSelectedNames,diseaseCellHeight,nutritionCellHeight,isFirstLoad;
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
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
    self.title = @"诊断结果";
    int totalFloor = [userPreferArray count]/4+ (([userPreferArray count]%4 == 0)?0:1);
    self.nutritionCellHeight = totalFloor *30 + 20+ (totalFloor-1)*8;
    CGSize labelSize = [userSelectedNames sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
    self.diseaseCellHeight = labelSize.height + 20;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return 0;
    }
    else
    {
        return 0;
    }
                    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
    
        LZEmptyClassCell * cell =(LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"UserDiseaseCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, self.diseaseCellHeight -20)];
            [contentLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8]];
            [contentLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:contentLabel];
            contentLabel.numberOfLines = 0;
            [contentLabel setFont:[UIFont systemFontOfSize:15]];
            contentLabel.text = userSelectedNames;
            cell.hasLoaded = YES;
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        LZEmptyClassCell * cell =(LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"ResultNutritionCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            int floor = 1;
            int countPerRow = 4;
            float startX;
            LZDataAccess *da =[LZDataAccess singleton];
            for (int i = 0; i< [self.userPreferArray count];i++)
            {
                if (i>=floor *countPerRow)
                {
                    floor+=1;
                }
                startX = 10+(i-(floor-1)*countPerRow)*77;
                UIButton *nutrientButton = [[UIButton alloc]initWithFrame:CGRectMake(startX, 10+(floor-1)*38, 69, 30)];
                [cell.contentView addSubview:nutrientButton];
                nutrientButton.tag = 101+i;
                [nutrientButton addTarget:self action:@selector(nutrientButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                NSString *key = [userPreferArray objectAtIndex:i];
                NSDictionary *dict = [da getNutrientInfo:key];
                NSString *name = [dict objectForKey:@"NutrientCnCaption"];
                [nutrientButton setTitle:name forState:UIControlStateNormal];
                [nutrientButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:key];
                [nutrientButton setBackgroundColor:fillColor];
                [nutrientButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [nutrientButton.layer setCornerRadius:3.0f];
                [nutrientButton.layer setMasksToBounds:YES];
            }
            cell.hasLoaded = YES;
            return cell;
        }

    }
    else if (indexPath.section == 2)
    {
        
    }
    else
    {
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.diseaseCellHeight;
    }
    else if(indexPath.section == 1)
    {
        return self.nutritionCellHeight;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 0;
    }
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return nil;
    }
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section ==2)
    {
        return 80;
    }
    return 27;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
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
    
    if (section ==0)
    {
        sectionTitleLabel.text =  @"您所选的症状";
    }
    else if (section == 1)
    {
        sectionTitleLabel.text = @"您需要补充的营养元素";
    }
    else if (section == 2)
    {
        sectionTitleLabel.text =  @"您可以考虑的食物";
    }
    else
    {
        sectionTitleLabel.text =  @"以上食物一天的营养比例";
    }
    
    
    return sectionView;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isFirstLoad)
    {
        return 2;
    }
    return 4;
}
-(void)nutrientButtonTapped:(UIButton *)nutrientButton
{
    int tag = nutrientButton.tag-101;
    NSString *key = [self.userPreferArray objectAtIndex:tag];
    [[LZNutrientionManager SharedInstance]showNutrientInfo:key];
}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    HUD.hidden = YES;
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
@end
