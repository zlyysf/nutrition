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
#import "LZConstants.h"
#import "LZRecommendFood.h"
#import "LZReviewAppManager.h"
#import "LZRecommendFoodCell.h"
#import "LZCheckNutritionCell.h"
#import "MobClick.h"
#import "GADMasterViewController.h"
#import "LZUserDietListViewController.h"
#import "LZMainPageViewController.h"
#import "LZRichNutritionViewController.h"
#import "LZHeavlyLackCell.h"
#import "LZNutritionButton.h"
@interface LZCheckResultViewController ()<MBProgressHUDDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *HUD;
    BOOL isChinese;
}
@property (assign,nonatomic)float diseaseCellHeight;
@property (assign,nonatomic)float lightCellHeight;
@property (assign,nonatomic)float heavyCellHeight;
@property (assign,nonatomic)BOOL isFirstLoad;
@end

@implementation LZCheckResultViewController
@synthesize userPreferArray,userSelectedNames,diseaseCellHeight,lightCellHeight,heavyCellHeight,isFirstLoad,recommendFoodDictForDisplay,takenFoodIdsArray,takenFoodDict,nutrientInfoArray,takenFoodNutrientInfoDict,allFoodUnitDict;
@synthesize heavylyLackArray,lightlyLackArray,userTotalScore,nutritionNameArray;
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
    if (ViewControllerUseBackImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    }
  
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
    self.title = NSLocalizedString(@"checkresult_viewtitle",@"诊断结果");

    int lightTotalFloor = [lightlyLackArray count]/3+ (([lightlyLackArray count]%3 == 0)?0:1);
    self.lightCellHeight = lightTotalFloor *94 + 20+ (lightTotalFloor-1)*8;
    int heavyTotalFloor = [heavylyLackArray count]/3+ (([heavylyLackArray count]%3 == 0)?0:1);
    self.heavyCellHeight = heavyTotalFloor *94 + 20+ (heavyTotalFloor-1)*8;

    CGSize labelSize = [userSelectedNames sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
    self.diseaseCellHeight = labelSize.height + 20;
    takenFoodIdsArray = [[NSMutableArray alloc]init];
    takenFoodDict = [[NSMutableDictionary alloc]init];
    nutrientInfoArray = [[NSMutableArray alloc]init];
    takenFoodNutrientInfoDict = [[NSMutableDictionary alloc]init];
    recommendFoodDictForDisplay = [[NSMutableDictionary alloc]init];
    allFoodUnitDict = [[NSMutableDictionary alloc]init];
    isFirstLoad = YES;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    self.listView.tableFooterView = footerView;
    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"fanhuibutton",@"  返回") forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 48, 30);
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
    if ([LZUtility isCurrentLanguageChinese])
    {
        isChinese = YES;
    }
    else{
        isChinese = NO;
    }


	// Do any additional setup after loading the view.
}
-(void)backButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:UmengPathZhenDuanJieGuo];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathZhenDuanJieGuo];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        HUD.hidden = NO;
        [HUD show:YES];
        self.listView.hidden = YES;

        HUD.labelText = NSLocalizedString(@"checkresult_HUDLabel_content",@"智能推荐中...");

        [self performSelector:@selector(recommendOnePlan) withObject:nil afterDelay:0.f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >=0 && section <4)
    {
        return 1;
    }
    else if(section == 4)
    {
        return [takenFoodIdsArray count];
    }
    else
    {
       return [nutrientInfoArray count];
    }
                    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        LZEmptyClassCell * cell =(LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"UserScoreCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            UIColor *scoreColor;
            if (self.userTotalScore >= 90)
            {
                scoreColor = [UIColor colorWithRed:61/255.f green:175/255.f blue:44/255.f alpha:1.0f];
            }
            else if (self.userTotalScore >= 60)
            {
                scoreColor = [UIColor colorWithRed:255/255.f green:230/255.f blue:33/255.f alpha:1.0f];
            }
            else
            {
                scoreColor = [UIColor colorWithRed:255/255.f green:33/255.f blue:33/255.f alpha:1.0f];
            }

            NSString *scoreString = [NSString stringWithFormat:@"%d%@",self.userTotalScore,NSLocalizedString(@"checkresult_resultfen",@"分")];
            CGSize labelSize = [scoreString sizeWithFont:[UIFont boldSystemFontOfSize:48]constrainedToSize:CGSizeMake(140, 9999) lineBreakMode:UILineBreakModeWordWrap];
            UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 140, labelSize.height)];
            [scoreLabel setTextColor:scoreColor];
            [scoreLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:scoreLabel];
            [scoreLabel setFont:[UIFont boldSystemFontOfSize:48]];
            scoreLabel.text = scoreString;
            scoreLabel.textAlignment = UITextAlignmentCenter;
            CGPoint scoreCenter = scoreLabel.center;
            
            NSString *summaryString;
            if (self.userTotalScore >= 90)
            {
                summaryString = NSLocalizedString(@"checkresult_result_summary0",@"恭喜，您现在的身体很健康！");
            }
            else if (self.userTotalScore >= 60)
            {
                summaryString = NSLocalizedString(@"checkresult_result_summary1",@"恭喜，您现在的身体比较健康！");
            }
            else
            {
                summaryString = NSLocalizedString(@"checkresult_result_summary2",@"抱歉，您现在的身体比较糟糕！");
            }
            CGSize labelSize1 = [summaryString sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(150, 9999) lineBreakMode:UILineBreakModeWordWrap];
            UILabel *healthSummaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 1, 150, labelSize1.height)];
            healthSummaryLabel.numberOfLines = 0;
            [healthSummaryLabel setTextColor:[UIColor blackColor]];
            [healthSummaryLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:healthSummaryLabel];
            [healthSummaryLabel setFont:[UIFont systemFontOfSize:15]];
            healthSummaryLabel.text = summaryString;
            CGPoint summaryCenter = healthSummaryLabel.center;
            summaryCenter.y = scoreCenter.y;
            healthSummaryLabel.center = summaryCenter;

            UIImageView *healthBar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 78, 300, 30)];
            [cell.contentView addSubview:healthBar];
            [healthBar setImage:[UIImage imageNamed:@"health_bar.png"]];
            
            UIImageView *healthPoint = [[UIImageView alloc]initWithFrame:CGRectMake(10, 65, 35, 40)];
            [healthPoint setImage:[UIImage imageNamed:@"health_point.png"]];
            [cell.contentView addSubview:healthPoint];
            CGPoint myCenter = healthPoint.center;
            int newX = 45 + (self.userTotalScore*230)/100;
            myCenter.x = newX;
            healthPoint.center = myCenter;
            
            cell.hasLoaded = YES;
            return cell;
        }

    }
    else if (indexPath.section == 1)
    {
        LZEmptyClassCell * cell =(LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"UserDiseaseCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, self.diseaseCellHeight -20)];
            [contentLabel setTextColor:[UIColor blackColor]];
            [contentLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:contentLabel];
            contentLabel.numberOfLines = 0;
            [contentLabel setFont:[UIFont systemFontOfSize:15]];
            contentLabel.text = userSelectedNames;
            cell.hasLoaded = YES;
            return cell;
        }

    }
    else if (indexPath.section == 2)
    {
        LZEmptyClassCell * cell =(LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"NutritionHeavyLackCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            if ([self.heavylyLackArray count] != 0)
            {
                float startY = 10;
                int floor = 1;
                int perRowCount = 3;
                float startX;
                for (int i=0; i< [self.heavylyLackArray count]; i++)
                {
                    
                    if (i>=floor *perRowCount)
                    {
                        floor+=1;
                    }
                    startX = 10+(i-(floor-1)*perRowCount)*102;
                    NSString *nutritionId = [self.heavylyLackArray objectAtIndex:i];
                    LZDataAccess *da = [LZDataAccess singleton];
                    NSDictionary *dict = [da getNutrientInfo:nutritionId];
                    UIColor *backColor = [LZUtility getNutrientColorForNutrientId:nutritionId];
                    NSString *queryKey;
                    if (isChinese)
                    {
                        queryKey = @"IconTitleCn";
                    }
                    else
                    {
                        queryKey = @"IconTitleEn";
                    }
                    NSString *nutritionName = [dict objectForKey:queryKey];
                    NSDictionary *info = [LZUtility getNutritionNameInfo:nutritionName];
                    UIImage*backImage = [LZUtility createImageWithColor:backColor imageSize:CGSizeMake(94, 94)];
                    LZNutritionButton *button = [[LZNutritionButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*102, 94, 94) info:info image:backImage];
                    button.customData = nutritionId;
                    [button addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button];
                }
            }
            else
            {
                NSString *content = NSLocalizedString(@"checkresult_nolightlylack",@"无，请关注轻度缺乏的营养！");
                CGSize descriptionSize = [content sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
                UILabel *emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, descriptionSize.width, descriptionSize.height)];
                emptyLabel.numberOfLines = 0;
                [emptyLabel setFont:[UIFont systemFontOfSize:15]];
                [emptyLabel setTextColor:[UIColor blackColor]];
                [cell.contentView addSubview:emptyLabel];
                emptyLabel.text = content;

            }
            cell.hasLoaded = YES;
            return cell;
        }
    }
    else if (indexPath.section == 3)
    {
        LZEmptyClassCell * cell =(LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"NutritionLightLackCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            if ([self.lightlyLackArray count]!= 0)
            {
                float startY = 10;
                int floor = 1;
                int perRowCount = 3;
                float startX;
                for (int i=0; i< [self.lightlyLackArray count]; i++)
                {
                    
                    if (i>=floor *perRowCount)
                    {
                        floor+=1;
                    }
                    startX = 10+(i-(floor-1)*perRowCount)*102;
                    NSString *nutritionId = [self.lightlyLackArray objectAtIndex:i];
                    LZDataAccess *da = [LZDataAccess singleton];
                    NSDictionary *dict = [da getNutrientInfo:nutritionId];
                    UIColor *backColor = [LZUtility getNutrientColorForNutrientId:nutritionId];
                    NSString *queryKey;
                    if (isChinese)
                    {
                        queryKey = @"IconTitleCn";
                    }
                    else
                    {
                        queryKey = @"IconTitleEn";
                    }
                    NSString *nutritionName = [dict objectForKey:queryKey];
                    NSDictionary *info = [LZUtility getNutritionNameInfo:nutritionName];
                    UIImage*backImage = [LZUtility createImageWithColor:backColor imageSize:CGSizeMake(94, 94)];
                    LZNutritionButton *button = [[LZNutritionButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*102, 94, 94) info:info image:backImage];
                    button.customData = nutritionId;
                    [button addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button];
                }
            }
            else
            {
                NSString *content = NSLocalizedString(@"checkresult_noheavylylack",@"无，请关注严重缺乏的营养！");
                CGSize descriptionSize = [content sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
                UILabel *emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, descriptionSize.width, descriptionSize.height)];
                emptyLabel.numberOfLines = 0;
                [emptyLabel setFont:[UIFont systemFontOfSize:15]];
                [emptyLabel setTextColor:[UIColor blackColor]];
                [cell.contentView addSubview:emptyLabel];
                emptyLabel.text = content;
            }
            cell.hasLoaded = YES;
            return cell;            
        }

    }
    else if (indexPath.section == 4)
    {
        LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
        NSString *foodId = [takenFoodIdsArray objectAtIndex:indexPath.row];
        NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
        //NSLog(@"picture path %@",aFood);
        if([self.recommendFoodDictForDisplay objectForKey:foodId])
        {
            cell.recommendSignImageView.hidden = NO;
        }
        else
        {
            cell.recommendSignImageView.hidden = YES;
        }
        NSString *picturePath;
        NSString *picPath = [aFood objectForKey:@"PicturePath"];
        if (picPath == nil || [picPath isEqualToString:@""])
        {
            picturePath = [[NSBundle mainBundle]pathForResource:@"defaulFoodPic" ofType:@"png"];
        }
        else
        {
            NSString * picFolderPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"foodDealed"];
            picturePath = [picFolderPath stringByAppendingPathComponent:picPath];
        }
        UIImage *foodImage = [UIImage imageWithContentsOfFile:picturePath];
        [cell.foodImageView setImage:foodImage];
        cell.cellFoodId = foodId;
        
        NSNumber *weight = [aFood objectForKey:@"Amount"];
        cell.foodUnitLabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
        NSDictionary *foodAtr = [allFoodUnitDict objectForKey:foodId];
        NSString *singleUnitName = [LZUtility getSingleItemUnitName:[foodAtr objectForKey:COLUMN_NAME_SingleItemUnitName]];
        NSString *foodTotalUnit = @"";
        if ([singleUnitName length]==0)
        {
            foodTotalUnit = @"";
        }
        else
        {
            NSNumber *singleUnitWeight = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
            int maxCount = (int)(ceilf(([weight floatValue]*2)/[singleUnitWeight floatValue]));
            //int unitCount = (int)((float)([weight floatValue]/[singleUnitWeight floatValue])+0.5);
            if (maxCount <= 0)
            {
                foodTotalUnit = @"";
            }
            else
            {
                if (maxCount %2 == 0)
                {
                    foodTotalUnit = [NSString stringWithFormat:@"(%d%@)",(int)(maxCount*0.5f),singleUnitName];
                }
                else
                {
                    foodTotalUnit = [NSString stringWithFormat:@"(%.1f%@)",maxCount*0.5f,singleUnitName];
                }

            }
        }
        NSString *foodNameKey;
        if (isChinese)
        {
            foodNameKey = @"CnCaption";
        }
        else
        {
            foodNameKey = @"FoodNameEn";
        }
        NSString *foodName = [foodAtr objectForKey:foodNameKey];
        cell.foodNameLabel.text = [NSString stringWithFormat:@"%@ %@",foodName,foodTotalUnit];
        return cell;
    }
    else
    {
        LZCheckNutritionCell *cell = (LZCheckNutritionCell *)[tableView dequeueReusableCellWithIdentifier:@"LZCheckNutritionCell"];
        NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
        //[cell.nutritionNameButton setTitle:[nutrient objectForKey:@"Name"] forState:UIControlStateNormal];
        NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
        
        UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:nutrientId];
        NSNumber *percent = [nutrient objectForKey:@"nutrientSupplyRate"];
        float progress = [percent floatValue]>1.f ? 1.f :[percent floatValue];
        float radius;
        if (progress >0.03 )
        {
            radius = 4;
        }
        else
        {
            radius = 2;
        }
        //CGRectMake(2,2,196,14)
        [cell.nutritionProgressView drawProgressForRect:CGRectMake(2,2,216,14) backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:7.f fillRadius:radius];
        [cell adjustLabelAccordingToProgress:progress forLabelWidth:216];
        cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)(floorf([percent floatValue] *100))];
        //NSSet *selectNutrient = [NSSet setWithArray:self.userPreferArray];
        NSSet *heavySet = [NSSet setWithArray:self.heavylyLackArray];
        NSSet *lightSet = [NSSet setWithArray:self.lightlyLackArray];
//        LZDataAccess *da = [LZDataAccess singleton];
//        NSDictionary *dict = [da getNutrientInfo:nutrientId];
//        NSString *queryKey;
//        if ([LZUtility isCurrentLanguageChinese])
//        {
//            queryKey = @"NutrientCnCaption";
//        }
//        else
//        {
//            queryKey = @"NutrientEnCaption";
//        }
        NSString *nutritionName = [self.nutritionNameArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = nutritionName;
        if ([heavySet containsObject:nutrientId])
        {
            [cell.nameLabel setFont:[UIFont boldSystemFontOfSize:16]];
            [cell.nameLabel setTextColor:[UIColor colorWithRed:255/255.f green:33/255.f blue:33/255.f alpha:1.0f]];
        }
        else if([lightSet containsObject:nutrientId])
        {
            [cell.nameLabel setFont:[UIFont boldSystemFontOfSize:16]];
            [cell.nameLabel setTextColor: [UIColor colorWithRed:255/255.f green:158/255.f blue:33/255.f alpha:1.0f]];
        }
        else
        {
            [cell.nameLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.nameLabel setTextColor:[UIColor blackColor]];
        }
        //cell.addFoodButton.tag = indexPath.row;
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 118;
    }
    if (indexPath.section == 1)
    {
        return self.diseaseCellHeight;
    }
    else if(indexPath.section == 2)
    {
        if ([self.heavylyLackArray count]!=0)
        {
            return self.heavyCellHeight;
        }
        else
        {
            NSString *content = NSLocalizedString(@"checkresult_nolightlylack",@"无，请关注轻度缺乏的营养！");
            CGSize descriptionSize = [content sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
            return descriptionSize.height+20;
        }
    }
    else if(indexPath.section == 3)
    {
        if ([self.lightlyLackArray count]!=0)
        {
            return self.lightCellHeight;
        }
        else
        {
            NSString *content = NSLocalizedString(@"checkresult_noheavylylack",@"无，请关注严重缺乏的营养！");
            CGSize descriptionSize = [content sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
            return descriptionSize.height+20;
        }
    }
    else if (indexPath.section ==4)
    {
        return 60;
    }
    else
    {
        return 42;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 ||section == 1 ||section == 3)
    {
        return 0;
    }
    if (section == 2)
    {
        if ([self.heavylyLackArray count] == 0)
        {
            return 0;
        }
        return 10;
    }
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 ||section == 1 ||section == 3)
    {
        return nil;
    }
    if (section == 2)
    {
        if ([self.heavylyLackArray count] == 0)
        {
            return nil;
        }

    }
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else if(section == 4)
    {
        return 82;
    }
    else
    {
        return 27;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 82)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *sectionBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
    [sectionView addSubview:sectionBarView];
    NSString *path ;
    if (section == 2)
    {
        path = [[NSBundle mainBundle] pathForResource:@"heavy_lack_bar@2x" ofType:@"png"];
    }
    else if (section == 3)
    {
        path = [[NSBundle mainBundle] pathForResource:@"light_lack_bar@2x" ofType:@"png"];
    }
    else
    {
        path = [[NSBundle mainBundle] pathForResource:@"section_bar@2x" ofType:@"png"];
    }
    
    UIImage * sectionBarImage = [UIImage imageWithContentsOfFile:path];
    [sectionBarView setImage:sectionBarImage];
    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 27)];
    [sectionTitleLabel setTextColor:[UIColor whiteColor]];
    [sectionTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:sectionTitleLabel];
    
    if (section ==1)
    {
        sectionTitleLabel.text =  NSLocalizedString(@"checkresult_section1_title",@"您所选的症状");
    }
    else if (section == 2)
    {
        if ([self.heavylyLackArray count]==0)
        {
            sectionTitleLabel.text = NSLocalizedString(@"checkresult_section2_title1",@"您现在体内严重缺乏的营养");
        }
        else
        {
            sectionTitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"checkresult_section2_title2",@"您现在体内严重缺乏%d种营养"),[self.heavylyLackArray count]];
        }
    }
    else if (section == 3)
    {
        if([self.lightlyLackArray count]==0)
        {
            sectionTitleLabel.text = NSLocalizedString(@"checkresult_section3_title1",@"您现在体内轻度缺乏的营养");
        }
        else
        {
            sectionTitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"checkresult_section3_title2",@"您现在体内轻度缺乏%d种营养"),[self.lightlyLackArray count]];
        }
    }
    else if (section == 4)
    {
        sectionTitleLabel.text =  NSLocalizedString(@"checkresult_section4_title",@"您需要补充的食物");
        UIImage *button30 = [[UIImage imageNamed:@"button_back_40"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIButton *recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recommendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [recommendButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [recommendButton setFrame:CGRectMake(10, 37, 145, 40)];
        [recommendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [recommendButton setTitle:NSLocalizedString(@"huanyizubutton",@"换一组") forState:UIControlStateNormal];
        [recommendButton addTarget:self action:@selector(changeRecommend) forControlEvents:UIControlEventTouchUpInside];
        [recommendButton setBackgroundImage:button30 forState:UIControlStateNormal];
        
        UIButton *saveDietButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveDietButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [saveDietButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [saveDietButton setFrame:CGRectMake(165, 37, 145, 40)];
        [saveDietButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveDietButton setTitle:NSLocalizedString(@"baocunbutton1",@"保  存") forState:UIControlStateNormal];
        [saveDietButton addTarget:self action:@selector(saveToDiet) forControlEvents:UIControlEventTouchUpInside];
        [saveDietButton setBackgroundImage:button30 forState:UIControlStateNormal];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, 320, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
        [sectionView addSubview:lineView];
        [sectionView addSubview:recommendButton];
        [sectionView addSubview:saveDietButton];
        if (ViewControllerUseBackImage) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
            UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
            [sectionView setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];

        }
    }
    else
    {
        sectionTitleLabel.text =  NSLocalizedString(@"checkresult_section5_title",@"以上食物一天的营养比例");
    }
    
    return sectionView;

}
-(void)saveToDiet
{
    if([self.takenFoodIdsArray count] == 0)
    {
        if([self.takenFoodIdsArray count] == 0)
        {
            UIAlertView *foodEmptyAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") message:NSLocalizedString(@"checkresult_alert0_message",@"食物列表还是空的呢!") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
            [foodEmptyAlert show];
            return;
        }
    }
    else
    {
        //新建一个表单，用insert
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
        NSString *localeId;
        if (isChinese)
        {
            localeId = @"zh";
        }
        else
        {
            localeId = @"en";
        }
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeId]];
        [formatter setDateFormat:NSLocalizedString(@"checkresult_savefoodalert_content1",@"MM月dd号")];
        NSString* time = [formatter stringFromDate:now];
        NSString *text = [NSString stringWithFormat:NSLocalizedString(@"checkresult_savefoodalert_content2",@"%@的饮食计划"),time];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"checkresult_alert1_title",@"保存清单") message:NSLocalizedString(@"checkresult_alert1_message",@"给你的食物清单加个名称吧!" )delegate:self cancelButtonTitle:NSLocalizedString(@"quxiaobutton",@"取消") otherButtonTitles:NSLocalizedString(@"quedingbutton",@"确定"), nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 102;
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.clearButtonMode = UITextFieldViewModeAlways;
        tf.text = text;
        [alert show];
        
    }

}
-(void)changeRecommend
{
    HUD.hidden = NO;
    [HUD show:YES];
    
    HUD.labelText = NSLocalizedString(@"checkresult_HUDLabel_content",@"智能推荐中...");
    
    [self performSelector:@selector(recommendOnePlan) withObject:nil afterDelay:0.f];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (void)recommendOnePlan
{
    [MobClick event:UmengEventHuanYiZu];
    NSArray *preferNutrient = [[NSUserDefaults standardUserDefaults]objectForKey:KeyUserRecommendPreferNutrientArray];
    NSSet *selectNutrient = [NSSet setWithArray:self.userPreferArray];
    NSMutableArray *newPreferArray = [[NSMutableArray alloc]init];
    for (NSDictionary *aNutrient in preferNutrient)
    {
        NSString *nId = [[aNutrient allKeys]objectAtIndex:0];
        if ([selectNutrient containsObject:nId])
        {
            NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],nId, nil];
            [newPreferArray addObject:newDict];
        }
        else
        {
            NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],nId, nil];
            [newPreferArray addObject:newDict];
        }
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userSex = [userDefaults objectForKey:LZUserSexKey];
    NSNumber *userAge = [userDefaults objectForKey:LZUserAgeKey];
    NSNumber *userHeight = [userDefaults objectForKey:LZUserHeightKey];
    NSNumber *userWeight = [userDefaults objectForKey:LZUserWeightKey];
    NSNumber *userActivityLevel = [userDefaults objectForKey:LZUserActivityLevelKey];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                userSex,ParamKey_sex, userAge,ParamKey_age,
                                                                userWeight,ParamKey_weight, userHeight,ParamKey_height,
                                                                userActivityLevel,ParamKey_activityLevel, nil];
    
    
    BOOL needConsiderNutrientLoss = FALSE;
    BOOL needUseDefinedIncrementUnit = TRUE;
    BOOL needUseNormalLimitWhenSmallIncrementLogic = TRUE;
    BOOL needUseFirstRecommendWhenSmallIncrementLogic = TRUE;//FALSE;
    BOOL needSpecialForFirstBatchFoods = FALSE; //TRUE;
    BOOL needFirstSpecialForShucaiShuiguo = TRUE;
    BOOL alreadyChoosedFoodHavePriority = TRUE;
    BOOL needPriorityFoodToSpecialNutrient = TRUE;
    int randSeed = 0; //0;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                                    //                    [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithBool:needUseDefinedIncrementUnit],LZSettingKey_needUseDefinedIncrementUnit,
                                    [NSNumber numberWithBool:needUseNormalLimitWhenSmallIncrementLogic],LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic,
                                    [NSNumber numberWithBool:needUseFirstRecommendWhenSmallIncrementLogic],LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic,
                                    [NSNumber numberWithBool:needSpecialForFirstBatchFoods],LZSettingKey_needSpecialForFirstBatchFoods,
                                    [NSNumber numberWithBool:needFirstSpecialForShucaiShuiguo],LZSettingKey_needFirstSpecialForShucaiShuiguo,
                                    [NSNumber numberWithBool:alreadyChoosedFoodHavePriority],LZSettingKey_alreadyChoosedFoodHavePriority,
                                    [NSNumber numberWithBool:needPriorityFoodToSpecialNutrient],LZSettingKey_needPriorityFoodToSpecialNutrient,
                                    [NSNumber numberWithInt:randSeed],LZSettingKey_randSeed,
                                    nil];
    if (KeyIsEnvironmentDebug){
            NSDictionary *flagsDict = [[NSUserDefaults standardUserDefaults]objectForKey:KeyDebugSettingsDict];
            if (flagsDict.count > 0){
                    //            options = [NSMutableDictionary dictionaryWithDictionary:flagsDict];
                    [options setValuesForKeysWithDictionary:flagsDict];
                    assert([options objectForKey:LZSettingKey_randSeed]!=nil);
                }
        }
        
    NSArray *paramArray = [LZUtility convertPreferNutrientArrayToParamArray:newPreferArray];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:paramArray,Key_givenNutrients,nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodBySmallIncrementWithPreIntake:nil andUserInfo:userInfo andOptions:options andParams:params];
    NSDictionary *recommendFoodAmountDict = [retDict objectForKey:Key_recommendFoodAmountDict];
    [recommendFoodDictForDisplay removeAllObjects];
    [recommendFoodDictForDisplay addEntriesFromDictionary:recommendFoodAmountDict];
    [HUD hide:YES];
    self.listView.hidden = NO;
    [self refreshFoodNureitentProcessForAll:NO];
//    [self.listView setContentOffset:CGPointMake(0, 0) animated:NO];
    [[LZReviewAppManager SharedInstance]popReviewOurAppAlertAccordingRules];
    
}
-(void)refreshFoodNureitentProcessForAll:(BOOL)needRefreshAll
{
    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userSex = [userDefaults objectForKey:LZUserSexKey];
    NSNumber *userAge = [userDefaults objectForKey:LZUserAgeKey];
    NSNumber *userHeight = [userDefaults objectForKey:LZUserHeightKey];
    NSNumber *userWeight = [userDefaults objectForKey:LZUserWeightKey];
    NSNumber *userActivityLevel = [userDefaults objectForKey:LZUserActivityLevelKey];
    if (!(userSex && userAge && userHeight && userWeight && userActivityLevel))
    {
        return;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              userSex,ParamKey_sex, userAge,ParamKey_age,
                              userWeight,ParamKey_weight, userHeight,ParamKey_height,
                              userActivityLevel,ParamKey_activityLevel, nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userInfo,@"userInfo",
                            takenFoodAmountDict,@"givenFoodsAmount1",
                            self.recommendFoodDictForDisplay,@"givenFoodsAmount2",
                            nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retFmtDict = [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
//    NSLog(@" allkeys  %@",[retFmtDict allKeys]);
//    NSLog(@"calculateGiveFoodsSupplyNutrientAndFormatForUI %@",retFmtDict);
    
    NSArray *takenArray1 = [retFmtDict objectForKey:Key_orderedGivenFoodIds1];
    NSArray *takenArray2 = [retFmtDict objectForKey:Key_orderedGivenFoodIds2];
    [takenFoodIdsArray removeAllObjects];
    if (takenArray1 != nil && [takenArray1 count]!=0) {
        
        [takenFoodIdsArray addObjectsFromArray:takenArray1];
    }
    if (takenArray2 != nil && [takenArray2 count]!=0) {
        
        [takenFoodIdsArray addObjectsFromArray:takenArray2];
    }
    NSDictionary *foodUnitDict = [retFmtDict objectForKey:Key_givenFoodAttrDict2Level];
    [allFoodUnitDict removeAllObjects];
    if (foodUnitDict != nil )
    {
        [allFoodUnitDict addEntriesFromDictionary:foodUnitDict];
    }

    NSDictionary *takenDict = [retFmtDict objectForKey:Key_givenFoodInfoDict2Level];
    [takenFoodDict removeAllObjects];
    if (takenDict != nil )
    {
        
        [takenFoodDict addEntriesFromDictionary:takenDict];
    }
    
    NSDictionary *takenFoodNutrientDict = [retFmtDict objectForKey:Key_takenFoodNutrientInfoAryDictDict];
    [takenFoodNutrientInfoDict removeAllObjects];
    if (takenFoodNutrientDict != nil )
    {
        
        [takenFoodNutrientInfoDict addEntriesFromDictionary:takenFoodNutrientDict];
    }
    
    NSArray *nutrientArray = [retFmtDict objectForKey:Key_nutrientSupplyRateInfoArray];
    [nutrientInfoArray removeAllObjects];
    if (nutrientArray != nil && [nutrientArray count]!=0) {
        
        [nutrientInfoArray addObjectsFromArray:nutrientArray];
    }
    if (nutritionNameArray == nil || [nutritionNameArray count]==0)
    {
        nutritionNameArray = [[NSMutableArray alloc]init];
        LZDataAccess *da = [LZDataAccess singleton];
        
        NSString *queryKey;
        if (isChinese)
        {
            queryKey = @"NutrientCnCaption";
        }
        else
        {
            queryKey = @"NutrientEnCaption";
        }
        for (NSDictionary *nutrient in nutrientInfoArray)
        {
            NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
            NSDictionary *dict = [da getNutrientInfo:nutrientId];
            NSString *nutritionName = [dict objectForKey:queryKey];
            [nutritionNameArray addObject:nutritionName];
        }
    }

    if (needRefreshAll)
    {
        [self.listView reloadData];
    }
    else
    {
        NSRange range = NSMakeRange(4, 2);
        NSIndexSet *reloadSet = [[NSIndexSet alloc]initWithIndexesInRange:range];
        [self.listView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    //[self.listView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}
-(void)typeButtonTapped:(LZNutritionButton *)sender
{
    NSDictionary *emptyIntake = [[NSDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:emptyIntake forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *nutritionId = (NSString *)sender.customData;
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *dict = [da getNutrientInfo:nutritionId];
    NSString *queryKey;
    if (isChinese)
    {
        queryKey = @"NutrientCnCaption";
    }
    else
    {
        queryKey = @"NutrientEnCaption";
    }

    NSString *nutritionName = [dict objectForKey:queryKey];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZRichNutritionViewController *addByNutrientController = [storyboard instantiateViewControllerWithIdentifier:@"LZRichNutritionViewController"];
    addByNutrientController.nutrientDict = dict;
    addByNutrientController.nutrientTitle = nutritionName;
    [self.navigationController pushViewController:addByNutrientController animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 102)
    {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
            //            [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
            //            [[NSUserDefaults standardUserDefaults]synchronize];
            //            [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];
        }
        else
        {
            
            UITextField *textFiled = [alertView textFieldAtIndex:0];
            
            NSString *collocationName = textFiled.text;
            NSString *trimedName = [collocationName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([trimedName length] == 0)
            {
                UIAlertView *invalidNameAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") message:NSLocalizedString(@"checkresult_alert2_message",@"您输入的名称不规范，请重新输入") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles: nil];
                [invalidNameAlert show];
                return;
            }
            LZDataAccess *da = [LZDataAccess singleton];
            NSMutableArray * foodAndAmountArray = [NSMutableArray array];
            for (NSString *foodId in self.takenFoodIdsArray)
            {
                NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
                NSNumber *weight = [aFood objectForKey:@"Amount"];
                [foodAndAmountArray addObject:[NSArray arrayWithObjects:foodId, weight,nil]];
            }
            NSNumber *nmCollocationId = [da insertFoodCollocationData_withCollocationName:collocationName andFoodAmount2LevelArray:foodAndAmountArray];
            if(nmCollocationId)
            {
                UIAlertView *didSaveAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"checkresult_alert3_title",@"保存成功") message:NSLocalizedString(@"checkresult_alert3_message",@"您可以进入清单页面查看你的保存结果") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:NSLocalizedString(@"qukankanbutton",@"去看看"),nil];
                didSaveAlert.tag = 103;
                didSaveAlert.delegate = self;
                [didSaveAlert show];
            }
            else
            {
                UIAlertView *saveFailedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"checkresult_alert4_title",@"保存失败") message:NSLocalizedString(@"alertmessage_tryagain",@"出现了错误，请重试") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
                [saveFailedAlert show];
            }
        }
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 103)
    {
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LZMainPageViewController *mainPageViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZMainPageViewController"];
            LZUserDietListViewController *userDietListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZUserDietListViewController"];
            userDietListViewController.backWithNoAnimation = YES;
            NSArray *vcs = [NSArray arrayWithObjects:mainPageViewController,userDietListViewController, nil];
            UINavigationController *mainNav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [mainNav setViewControllers:vcs animated:YES];
        }

    }
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
