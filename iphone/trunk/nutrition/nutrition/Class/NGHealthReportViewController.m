//
//  NGHealthReportViewController.m
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGHealthReportViewController.h"
#import "NGReportBMICell.h"
#import "NGReportHealthScoreCell.h"
#import "LZCustomDataButton.h"
#import "LZDataAccess.h"
#import "LZUtility.h"
#import "LZNutrientionManager.h"
#import "NGIllnessInfoViewController.h"
#import "NGNutritionInfoViewController.h"
#import "NGSingleFoodViewController.h"
#import "LZConstants.h"
#import "LZEmptyClassCell.h"
#import "NGRecommendFoodView.h"
#define BorderColor [UIColor lightGrayColor].CGColor

#define AttentionItemLabelWidth 240
#define AttentionItemOrderlabelWidth 15
#define AttentionItemMargin 5
#define BigLabelFont [UIFont systemFontOfSize:22.f]
#define SmallLabelFont [UIFont systemFontOfSize:14.f]
#define MaxDisplayFoodCount 5
@interface NGHealthReportViewController ()
{
    BOOL isChinese;
}
@property (nonatomic,assign)BOOL isFirstLoad;
@property (nonatomic,strong)UIImage *selectedImage;
@property (nonatomic,strong)NSArray *illnessArray;
@property (nonatomic,assign)float illnessCellHeight;
@property (nonatomic,assign)float lackNutritonCellHeight;
@property (nonatomic,assign)float recommendFoodCellHeight;
@property (nonatomic,assign)float suggestionCellHeight;
@property (nonatomic,strong)UIView *recommendFoodView;
@end

@implementation NGHealthReportViewController
@synthesize lackNutritionArray,potentialArray,attentionArray,isFirstLoad,isFirstSave,recommendFoodDict,dataToSave,selectedImage,illnessArray,illnessCellHeight,lackNutritonCellHeight,recommendFoodCellHeight,suggestionCellHeight,recommendFoodView;
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
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    isFirstLoad = YES;
    isChinese = [LZUtility isCurrentLanguageChinese];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"jiankangbaogao_c_baocun", @"保存按钮：保存") style:UIBarButtonItemStyleBordered target:self action:@selector(saveRecord:)];
    self.navigationItem.rightBarButtonItem = saveItem;

    if (isFirstSave)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    LZDataAccess *da = [LZDataAccess singleton];
    self.illnessArray = [da getIllness_ByIllnessIds:potentialArray];
    selectedImage = [LZUtility createImageWithColor:ItemSelectedColor imageSize:CGSizeMake(300, 54)];
    self.title = NSLocalizedString(@"jiankangbaogao_c_title", @"页面标题：健康报告");
    if (self.lackNutritionArray != nil && [self.lackNutritionArray count]!= 0)
    {
        lackNutritonCellHeight =[self.lackNutritionArray count]*50+35;
    }
    else
    {
        lackNutritonCellHeight = 0;
    }
    if (self.lackNutritionArray != nil && [self.lackNutritionArray count]!= 0)
    {
        recommendFoodCellHeight =[self.lackNutritionArray count]*140+25;
        [self createRecommendView];
    }
    else
    {
        recommendFoodCellHeight = 0;
    }
    if (self.illnessArray != nil && [self.illnessArray count]!= 0)
    {
        illnessCellHeight = [self.illnessArray count]*50+35;
    }
    else
    {
        illnessCellHeight = 0;
    }
    suggestionCellHeight = [self calculateHeightForAttentionPart];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        //[self displayReport];
    }
}
-(void)createRecommendView
{
    recommendFoodView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, recommendFoodCellHeight)];
    [recommendFoodView setBackgroundColor:[UIColor whiteColor]];
    [recommendFoodView.layer setBorderColor:BorderColor];
    [recommendFoodView.layer setBorderWidth:0.5f];
    recommendFoodView.clipsToBounds = YES;
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
    [headerLabel setFont:SmallLabelFont];
    [headerLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:10.f]];
    [headerLabel setText:NSLocalizedString(@"jiankangbaogao_c_tuijianshiwu", @"推荐食物项标题：推荐食物")];
    [recommendFoodView addSubview:headerLabel];
    float startY = 35;
    NSString *foodQueryKey;
    NSString *queryKey;
    if (isChinese)
    {
        foodQueryKey = @"CnCaption";
        queryKey = @"IconTitleCn";
    }
    else
    {
        foodQueryKey = @"FoodNameEn";
        queryKey = @"IconTitleEn";
    }
    LZNutrientionManager*nm = [LZNutrientionManager SharedInstance];
    for (int i = 0; i<[lackNutritionArray count]; i++)
    {
        NSString *nutritionId = [self.lackNutritionArray objectAtIndex:i];
        NSDictionary *dict = [nm getNutritionInfo:nutritionId];
        NSString *nutritionName = [dict objectForKey:queryKey];
        NSArray *recommendFood = [self.recommendFoodDict objectForKey:nutritionId];
        UIScrollView *foodScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, startY, 300, 120)];
        [recommendFoodView addSubview:foodScrollView];
        int foodCount =[recommendFood count];
        [foodScrollView setContentSize:CGSizeMake(foodCount*94+35, 120)];
        foodScrollView.showsHorizontalScrollIndicator = NO;
        UILabel *nutritionNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 16, 120)];
        nutritionNameLabel.numberOfLines = 0;
        [nutritionNameLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0f]];
        [nutritionNameLabel setText:nutritionName];
        [nutritionNameLabel setFont:SmallLabelFont];
        [nutritionNameLabel setTextAlignment:UITextAlignmentCenter];
        [foodScrollView addSubview:nutritionNameLabel];
        
        for (int k = 0; k<foodCount; k++)
        {
            NSDictionary *foodInfo = [recommendFood objectAtIndex:k];
            NSString *picturePath;
            NSString *picPath = [foodInfo objectForKey:@"PicPath"];
            if (picPath == nil || [picPath isEqualToString:@""])
            {
                picturePath = [[NSBundle mainBundle]pathForResource:@"defaulFoodPic" ofType:@"png"];
            }
            else
            {
                NSString * picFolderPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"foodDealed"];
                picturePath = [picFolderPath stringByAppendingPathComponent:picPath];
            }
            NSString *foodName = [foodInfo objectForKey:foodQueryKey];
            NSNumber *weight = [foodInfo objectForKey:@"FoodAmount"];
            NSString *singleUnitName = [LZUtility getSingleItemUnitName:[foodInfo objectForKey:COLUMN_NAME_SingleItemUnitName]];
            NSString *foodTotalUnit = @"";
            if ([singleUnitName length]==0)
            {
                foodTotalUnit = [NSString stringWithFormat:@"%dg",[weight intValue]];
            }
            else
            {
                NSNumber *singleUnitWeight = [foodInfo objectForKey:COLUMN_NAME_SingleItemUnitWeight];
                int maxCount = (int)(ceilf(([weight floatValue]*2)/[singleUnitWeight floatValue]));
                //int unitCount = (int)((float)([weight floatValue]/[singleUnitWeight floatValue])+0.5);
                if (maxCount <= 0)
                {
                    foodTotalUnit = [NSString stringWithFormat:@"%dg",[weight intValue]];
                }
                else
                {
                    if (maxCount %2 == 0)
                    {
                        foodTotalUnit = [NSString stringWithFormat:@"%d%@",(int)(maxCount*0.5f),singleUnitName];
                    }
                    else
                    {
                        foodTotalUnit = [NSString stringWithFormat:@"%.1f%@",maxCount*0.5f,singleUnitName];
                    }
                    
                }
            }
            NGRecommendFoodView *foodView = [[NGRecommendFoodView alloc]initWithFrame:CGRectMake(35+k*94, 0, 80, 120) foodName:foodName foodPic:picturePath foodAmount:foodTotalUnit];
            NSIndexPath *index = [NSIndexPath indexPathForRow:k inSection:i];
            foodView.touchButton.customData = index;
            [foodView.touchButton addTarget:self action:@selector(foodClicked:) forControlEvents:UIControlEventTouchUpInside];
            [foodScrollView addSubview:foodView];
            
        }
        if (i!= [lackNutritionArray count]-1 )
        {
            startY += 130;
            UIImageView *sepLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, startY, 300, 1)];
            [recommendFoodView  addSubview:sepLine];
            [sepLine setImage:[UIImage imageNamed:@"gray_horizon_line.png"]];
            [sepLine setContentMode:UIViewContentModeCenter];
            startY +=10;
        }
        
    }

}
-(void)saveRecord:(id)sender
{
    
    if (self.dataToSave)
    {
        LZDataAccess *da = [LZDataAccess singleton];
        NSNumber *dayLocalNum =[self.dataToSave objectForKey:@"dayLocal"];
        int dayLocal = [dayLocalNum intValue];
        NSDate *updateTime =[self.dataToSave objectForKey:@"date"];
        NSDictionary *InputNameValuePairsData = [self.dataToSave objectForKey:@"InputNameValuePairsData"];
        NSString *note = [self.dataToSave objectForKey:@"note"];
        NSDictionary *CalculateNameValuePairsData = [self.dataToSave objectForKey:@"CalculateNameValuePairsData"];
        
        if ([da updateUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:Notification_HistoryUpdatedKey object:nil];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            
            //to sync to remote parse service
            PFObject *parseObjUserRecord = [LZUtility getToSaveParseObject_UserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
            [parseObjUserRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSMutableString *msg = [NSMutableString string];
                if (succeeded){
                    [msg appendFormat:@"PFObject.saveInBackgroundWithBlock OK"];
                    [LZUtility saveParseObjectInfo_CurrentUserRecordSymptom_withParseObjectId:parseObjUserRecord.objectId andDayLocal:dayLocal];
                }else{
                    [msg appendFormat:@"PFObject.saveInBackgroundWithBlock ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
                }
                NSLog(@"when updateUserRecordSymptom_withDayLocal, %@",msg);
            }];//saveInBackgroundWithBlock
        }
    }
}
//-(void)displayReport
//{
//    float totalheight = 0;
//    float starty = 120;
//    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.topView.layer.borderWidth = 0.5f;
//    self.middleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.middleView.layer.borderWidth = 0.5f;
//    self.bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.bottomView.layer.borderWidth = 0.5f;
//    self.BMILabel.text = @"体质指数";
//    self.BMIScoreLabel.text = @"25.1";
//    self.BMIDescriptionLabel.text = @"超重了";
//    [self.BMIProgressBar setProgress:0.5f];
//    self.nutritionLevelLabel.text = @"健康指数";
//    self.nutritionScoreLabel.text = @"89";
//    self.lackNutritonLabel.text = @"缺乏营养";
//    self.recommendFoodLabel.text = @"推荐食物";
//    self.potentialLabel.text = @"潜在疾病";
//    self.attentionLabel.text = @"注意事项";
//    int lackCount =[self.lackNutritionArray count];
//    float middleViewHeight = NutritionItemStartY+ lackCount*NutritionItemLabelHeight+2*ItemTopMargin+(lackCount -1)*NutritionItemMargin+185;
//    [self.lackNutritonLabel setFrame:CGRectMake(10, NutritionItemStartY+(lackCount*NutritionItemLabelHeight+2*ItemTopMargin+(lackCount -1)*NutritionItemMargin-20)/2, 60, 20)];
//    [self.middleView setFrame:CGRectMake(10, starty, 300, middleViewHeight)];
//    for (int i=0 ; i< lackCount; i++)
//    {
//        UILabel *lackItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(NutritionItemStartX, NutritionItemStartY+ItemTopMargin+i*(NutritionItemLabelHeight+NutritionItemMargin), 140, NutritionItemLabelHeight)];
//        [self.middleView addSubview:lackItemLabel];
//        lackItemLabel.text = [self.lackNutritionArray objectAtIndex:i];
//        [lackItemLabel setFont:BigLabelFont];
//        [lackItemLabel setTextColor:[UIColor blackColor]];
//        [lackItemLabel setBackgroundColor:[UIColor clearColor]];
//        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(ItemDetailArrowStartX, 0, 20, 20)];
//        [self.middleView addSubview:arrowImage];
//        CGPoint lackLabelCenter = lackItemLabel.center;
//        CGPoint arrowCenter = CGPointMake(arrowImage.center.x, lackLabelCenter.y);
//        arrowImage.center = arrowCenter;
//        [arrowImage setImage:[UIImage imageNamed:@"item_detail_arrow.png"]];
//    }
//    int foodCount =[self.recommendFoodArray count];
//    [self.recommendFoodScrollView setContentSize:CGSizeMake(2+foodCount*(80+RecommendFoodMargin)-RecommendFoodMargin, RecommendScrollViewHeight)];
//    for (int l=0; l< foodCount; l++)
//    {
//        NSDictionary *foodInfo = [self.recommendFoodArray objectAtIndex:l];
//        NGRecommendFoodView *foodView = [[NGRecommendFoodView alloc]initWithFrame:CGRectMake(1+l*(80+RecommendFoodMargin), 15, 80, 120) foodInfo:foodInfo];
//        [self.recommendFoodScrollView addSubview:foodView];
//    }
//
//    int potentialCount = [self.potentialArray count];
//    float bottomPart1Height = ItemTopMargin+potentialCount*(NutritionItemLabelHeight+PotentialItemMargin)+BottomViewBottomMargin-PotentialItemMargin;
//    [self.potentialLabel setFrame:CGRectMake(10, (bottomPart1Height-20-(BottomViewBottomMargin-ItemTopMargin))/2, 60, 20)];
//    for (int j =0 ; j< potentialCount; j++)
//    {
//        UILabel *potentialItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(NutritionItemStartX, ItemTopMargin+j*(NutritionItemLabelHeight+PotentialItemMargin), 140, NutritionItemLabelHeight)];
//        [self.bottomView addSubview:potentialItemLabel];
//        potentialItemLabel.text = [self.potentialArray objectAtIndex:j];
//        [potentialItemLabel setFont:BigLabelFont];
//        [potentialItemLabel setTextColor:[UIColor blackColor]];
//        [potentialItemLabel setBackgroundColor:[UIColor clearColor]];
//        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(ItemDetailArrowStartX, 0, 20, 20)];
//        [self.bottomView addSubview:arrowImage];
//        CGPoint potentialLabelCenter = potentialItemLabel.center;
//        CGPoint arrowCenter = CGPointMake(arrowImage.center.x, potentialLabelCenter.y);
//        arrowImage.center = arrowCenter;
//        [arrowImage setImage:[UIImage imageNamed:@"item_detail_arrow.png"]];
//    }
//    [self.bottomSepLine setFrame:CGRectMake(0, bottomPart1Height, 300, 1)];
//    int attentionCount = [self.attentionArray count];
//    float bottomPart2Height = 0;
//    float attentionStartY = bottomPart1Height+ItemTopMargin;
//
//    float onelineHeight = [@"o" sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(PotentialItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
//    for (int k = 0; k<attentionCount; k++)
//    {
//        NSString *text = [self.attentionArray objectAtIndex:k];
//        CGSize textSize = [text sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(PotentialItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
//        UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(AttentionLabelStartX, attentionStartY, AttentionItemOrderlabelWidth, onelineHeight)];
//        [orderLabel setFont:SmallLabelFont];
//        [orderLabel setText:[NSString stringWithFormat:@"%d.",k+1]];
//        [orderLabel setTextColor:[UIColor blackColor]];
//        [self.bottomView addSubview:orderLabel];
//        UILabel *attentionItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(AttentionLabelStartX+AttentionItemOrderlabelWidth,attentionStartY, textSize.width, textSize.height)];
//        [attentionItemLabel setBackgroundColor:[UIColor clearColor]];
//        [attentionItemLabel setFont:SmallLabelFont];
//        [attentionItemLabel setNumberOfLines:0];
//        [attentionItemLabel setText:text];
//        [attentionItemLabel setTextColor:[UIColor blackColor]];
//        [self.bottomView addSubview:attentionItemLabel];
//        attentionStartY += (textSize.height+AttentionItemMargin);
//    }
//
//    float bottomViewHeight = attentionStartY+BottomViewBottomMargin-AttentionItemMargin;
//    bottomPart2Height = bottomViewHeight-bottomPart1Height;
//    [self.attentionLabel setFrame:CGRectMake(10, bottomPart1Height+(bottomPart2Height-20-(BottomViewBottomMargin-ItemTopMargin))/2, 60, 20)];
//    [self.bottomView setFrame:CGRectMake(10, starty+middleViewHeight+40, 300, bottomViewHeight)];
//    totalheight = 120+middleViewHeight+40+bottomViewHeight+20;
//    [self.mainScrollView setContentSize:CGSizeMake(320, totalheight)];
//    
//}
-(float)calculateHeightForAttentionPart
{

    if (self.attentionArray == nil || [self.attentionArray count]==0)
    {
        return 0;
    }
    else
    {
        int attentionCount = [self.attentionArray count];
        float height = 45;
        NSString *queryKey;
        if (isChinese)
        {
            queryKey = @"SuggestionCn";
        }
        else
        {
            queryKey = @"SuggestionEn";
        }
        for (int k = 0; k<attentionCount; k++)
        {
            NSDictionary *anItem = [attentionArray objectAtIndex:k];
            NSString *text = [anItem objectForKey:queryKey];
            
            CGSize textSize = [text sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(AttentionItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
            height+= (textSize.height+AttentionItemMargin);
        }
        height -=AttentionItemMargin;
        return height;
    }

}
-(void)nutritionButtonClicked:(LZCustomDataButton*)sender
{
    NSString *nutritionId = (NSString *)sender.customData;
    NSLog(@"%@",nutritionId);
    LZNutrientionManager *nm = [LZNutrientionManager SharedInstance];
    NSDictionary *dict = [nm getNutritionInfo:nutritionId];
    NSString *captionKey;
    NSString *urlKey;
    if (isChinese)
    {
        captionKey = @"NutrientCnCaption";
        urlKey = @"UrlCn";
    }
    else
    {
        captionKey = @"NutrientEnCaption";
        urlKey = @"UrlEn";
    }
    NSString *urlString = [dict objectForKey:urlKey];
    NSString *nutritionName = [dict objectForKey:captionKey];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGNutritionInfoViewController *nutritionInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGNutritionInfoViewController"];
    nutritionInfoViewController.title =nutritionName;
    nutritionInfoViewController.nutrientDict = dict;
    nutritionInfoViewController.requestUrl =urlString;
    [self.navigationController pushViewController:nutritionInfoViewController animated:YES];
}
-(void)illnessButtonClicked:(LZCustomDataButton*)sender
{
    NSNumber *illnessIndex = (NSNumber *)sender.customData;
    NSDictionary *illnessDict = [self.illnessArray objectAtIndex:[illnessIndex intValue]];
    NSString *urlKey;
    NSString *nameKey;
    if (isChinese)
    {
        urlKey = @"UrlCn";
        nameKey = @"IllnessNameCn";
    }
    else
    {
        urlKey = @"UrlEn";
        nameKey = @"IllnessNameEn";
    }
    NSString *illnessUrl = [illnessDict objectForKey:urlKey];
    NSString *illnessName = [illnessDict objectForKey:nameKey];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGIllnessInfoViewController *illnessInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGIllnessInfoViewController"];
    illnessInfoViewController.illnessURL = illnessUrl;
    illnessInfoViewController.title = illnessName;
    [self.navigationController pushViewController:illnessInfoViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 1;
    }
    else if (section == 2 || section == 3)
    {
        if ( self.lackNutritionArray != nil && [self.lackNutritionArray count]!= 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else if (section == 4)
    {
        if (self.illnessArray != nil && [self.illnessArray count]!=0)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if (self.attentionArray != nil && [self.attentionArray count]!= 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NGReportHealthScoreCell *cell = (NGReportHealthScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"NGReportHealthScoreCell"];
        if (!cell.hasLoaded)
        {
            [cell.backView.layer setBorderColor:BorderColor];
            [cell.backView.layer setBorderWidth:0.5f];
            cell.headerLabel.text = NSLocalizedString(@"jiankangbaogao_c_jiankangzhishu", @"健康指数栏标题：健康指数");
            //12,56,78 3,42,40,20
            NSString *scoreText =[LZUtility getAccurateStringWithDecimal:self.HealthValue];
            CGSize textSize = [scoreText sizeWithFont:[UIFont boldSystemFontOfSize:40.f] constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
            [cell.healthScoreLabel setFrame:CGRectMake(40, 35, textSize.width, 35)];
            [cell.fullPercentLabel setFrame:CGRectMake(40+textSize.width, 50, 40, 20)];
            cell.healthScoreLabel.text = scoreText;
            cell.hasLoaded = YES;
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        NGReportBMICell *cell = (NGReportBMICell*)[tableView dequeueReusableCellWithIdentifier:@"NGReportBMICell"];
        if (!cell.hasLoaded)
        {
            [cell.backView.layer setBorderColor:BorderColor];
            [cell.backView.layer setBorderWidth:0.5f];
            [cell.levelView.layer setBorderColor:BorderColor];
            [cell.levelView.layer setBorderWidth:0.5f];
            cell.headerLabel.text = NSLocalizedString(@"jiankangbaogao_c_tizhizhishu", @"体质指数栏标题：体质指数");
            cell.level1Label.text = NSLocalizedString(@"jiankangbaogao_c_guoqing", @"体质指数范围：过轻");
            cell.level2Label.text = NSLocalizedString(@"jiankangbaogao_c_zhengchang", @"体质指数范围：正常");
            cell.level3Label.text = NSLocalizedString(@"jiankangbaogao_c_guozhong", @"体质指数范围：过重");
            cell.level4Label.text = NSLocalizedString(@"jiankangbaogao_c_feipang", @"体质指数范围：肥胖");
            NSString *scoreText =[LZUtility getAccurateStringWithDecimal:self.BMIValue];
            cell.bmiValueLabel.text = scoreText;
            [cell setBMIValue:self.BMIValue];
        }
        return cell;
    }
    else if (indexPath.section == 2)
    {
        LZEmptyClassCell *cell = (LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"NGLackNutritonCell"];
        if (!cell.hasLoaded)
        {
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, lackNutritonCellHeight)];
            [backView setBackgroundColor:[UIColor whiteColor]];
            [backView.layer setBorderColor:BorderColor];
            [backView.layer setBorderWidth:0.5f];
            [cell.contentView addSubview:backView];
            
            UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
            [headerLabel setFont:SmallLabelFont];
            [headerLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:10.f]];
            [headerLabel setText:NSLocalizedString(@"jiankangbaogao_c_quefayingyan", @"缺乏营养项标题：缺乏营养")];
            [backView addSubview:headerLabel];
            NSString *queryKey;
            if (isChinese)
            {
                queryKey = @"IconTitleCn";
            }
            else
            {
                queryKey = @"IconTitleEn";
            }

            LZNutrientionManager*nm = [LZNutrientionManager SharedInstance];
            float startY = 32;
            for (int i=0; i<[self.lackNutritionArray count]; i++)
            {
                NSString *nutritionId = [self.lackNutritionArray objectAtIndex:i];
                
                NSDictionary *dict = [nm getNutritionInfo:nutritionId];
                NSString *nutritionName = [dict objectForKey:queryKey];
                LZCustomDataButton *nutritionNameButton = [[LZCustomDataButton alloc]initWithFrame:CGRectMake(0, startY, 300, 36)];
                [nutritionNameButton setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
                nutritionNameButton.customData = nutritionId;
                [nutritionNameButton addTarget:self action:@selector(nutritionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:nutritionNameButton];
                UILabel *nutritionNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, startY, 170, 36)];
                [nutritionNameLabel setText:nutritionName];
                [nutritionNameLabel setFont:BigLabelFont];
                [backView addSubview:nutritionNameLabel];
                
                UIImageView *detailArrow = [[UIImageView alloc]initWithFrame:CGRectMake(265, startY+8, 20, 20)];
                [detailArrow setImage:[UIImage imageNamed:@"item_detail_arrow.png"]];
                [backView addSubview:detailArrow];
                startY += 50;
                
            }
            cell.hasLoaded = YES;
        }
        return cell;
    }
    else if (indexPath.section == 3)
    {
        LZEmptyClassCell *cell = (LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"NGRecommendCell"];
        if (!cell.hasLoaded)
        {
            [cell.contentView addSubview:recommendFoodView];
            cell.hasLoaded = YES;
        }
        return cell;
    }
    else if (indexPath.section == 4)
    {
        LZEmptyClassCell *cell = (LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"NGIllnessCell"];
        if (!cell.hasLoaded)
        {
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, illnessCellHeight)];
            [backView setBackgroundColor:[UIColor whiteColor]];
            [backView.layer setBorderColor:BorderColor];
            [backView.layer setBorderWidth:0.5f];
            [cell.contentView addSubview:backView];
            
            UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
            [headerLabel setFont:SmallLabelFont];
            [headerLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:10.f]];
            [headerLabel setText:NSLocalizedString(@"jiangkangbaogao_c_qianzaishiwu", @"潜在疾病项标题：潜在疾病")];
            [backView addSubview:headerLabel];
            NSString *illnessNameKey;
            if (isChinese) {
                illnessNameKey =@"IllnessNameCn";
            }
            else
            {
                illnessNameKey =@"IllnessNameEn";
            }

            float startY = 32;
            for (int i= 0;i< [self.illnessArray count];i++)
            {
                LZCustomDataButton *illnessButton = [[LZCustomDataButton alloc]initWithFrame:CGRectMake(0, startY, 300, 36)];
                illnessButton.customData =[NSNumber numberWithInt:i];
                [illnessButton addTarget:self action:@selector(illnessButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [illnessButton setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
                [backView addSubview:illnessButton];
                
                UILabel *illnessNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, startY, 172, 36)];
                [illnessNameLabel setFont:BigLabelFont];
                [illnessNameLabel setTextColor:[UIColor blackColor]];
                NSDictionary *illnessDict = [self.illnessArray objectAtIndex:i];
                NSString *illnessName = [illnessDict objectForKey:illnessNameKey];
                [illnessNameLabel setText:illnessName];
                [illnessNameLabel setBackgroundColor:[UIColor clearColor]];
                [backView addSubview:illnessNameLabel];
                
                UIImageView *detailArrow = [[UIImageView alloc]initWithFrame:CGRectMake(265, startY+8, 20, 20)];
                [detailArrow setImage:[UIImage imageNamed:@"item_detail_arrow.png"]];
                [backView addSubview:detailArrow];
                
                startY += 50;

            }
            cell.hasLoaded = YES;
        }
        return cell;
    }
    else
    {
        LZEmptyClassCell *cell = (LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"NGSuggestionCell"];
        if (!cell.hasLoaded)
        {
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, suggestionCellHeight)];
            [backView setBackgroundColor:[UIColor whiteColor]];
            [backView.layer setBorderColor:BorderColor];
            [backView.layer setBorderWidth:0.5f];
            [cell.contentView addSubview:backView];
            
            UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
            [headerLabel setFont:SmallLabelFont];
            [headerLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:10.f]];
            [headerLabel setText:NSLocalizedString(@"jiankangbaogao_c_zhuyishixiang", @"注意事项项标题：注意事项")];
            [backView addSubview:headerLabel];
            NSString *suggestionQueryKey;
            if (isChinese)
            {
                suggestionQueryKey = @"SuggestionCn";
            }
            else
            {
                suggestionQueryKey = @"SuggestionEn";
            }
            float onelineHeight = [@"o" sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(AttentionItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
            int k=1;
            float startY = 35;
            for (NSDictionary *anSuggestion in attentionArray)
            {
                NSString *text = [anSuggestion objectForKey:suggestionQueryKey];
                CGSize textSize = [text sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(AttentionItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
                UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, startY, AttentionItemOrderlabelWidth, onelineHeight)];
                [orderLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0f]];
                [orderLabel setFont:SmallLabelFont];
                [orderLabel setText:[NSString stringWithFormat:@"%d",k]];
                [orderLabel setTextColor:[UIColor blackColor]];
                [backView addSubview:orderLabel];
                
                UILabel *attentionItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(40,startY, textSize.width, textSize.height)];
                [attentionItemLabel setBackgroundColor:[UIColor clearColor]];
                [attentionItemLabel setFont:SmallLabelFont];
                [attentionItemLabel setNumberOfLines:0];
                [attentionItemLabel setText:text];
                [attentionItemLabel setTextColor:[UIColor blackColor]];
                [backView addSubview:attentionItemLabel];
                startY+= (textSize.height+AttentionItemMargin);
                k+=1;
            }
            cell.hasLoaded = YES;
        }
        return cell;
    }
}
-(void)setBgColorForButton:(UIButton*)sender
{
    [sender setBackgroundColor:ItemSelectedColor];
}

-(void)clearBgColorForButton:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 100;
    }
    else if (indexPath.section == 1)
    {
        return 150;
    }
    else if (indexPath.section == 2)
    {
        return lackNutritonCellHeight+20;
    }
    else if (indexPath.section == 3)
    {
        return recommendFoodCellHeight+20;
    }
    else if (indexPath.section == 4)
    {
        return illnessCellHeight +20;
    }
    else
    {
        return suggestionCellHeight+20;
    }
}
-(void)foodClicked:(LZCustomDataButton *)sender
{
    NSIndexPath *foodIndex = (NSIndexPath *)sender.customData;
    NSString *nutritionId = [self.lackNutritionArray objectAtIndex:foodIndex.section];
    NSArray *recommendFood = [self.recommendFoodDict objectForKey:nutritionId];
    NSDictionary *foodAtr = [recommendFood objectAtIndex:foodIndex.row];
    NSString *foodQueryKey;
    if (isChinese)
    {
        foodQueryKey = @"CnCaption";
    }
    else
    {
        foodQueryKey = @"FoodNameEn";
    }
    NSString *foodName = [foodAtr objectForKey:foodQueryKey];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGSingleFoodViewController *singleFoodViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGSingleFoodViewController"];
    singleFoodViewController.title = foodName;
    singleFoodViewController.foodInfoDict = foodAtr;
    [self.navigationController pushViewController:singleFoodViewController animated:YES];
}
@end
