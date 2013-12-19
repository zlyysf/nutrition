//
//  NGHealthReportViewController.m
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGHealthReportViewController.h"
#import "NGReportBMICell.h"
#import "NGReportDiseaseCell.h"
#import "NGReportHealthScoreCell.h"
#import "NGReportNutritonFoodCell.h"
#import "LZDataAccess.h"
#import "LZUtility.h"
#import "LZNutrientionManager.h"
#import "NGIllnessInfoViewController.h"
#import "NGNutritionInfoViewController.h"
#import "NGSingleFoodViewController.h"
#import "LZConstants.h"
#define BorderColor [UIColor lightGrayColor].CGColor

#define AttentionItemLabelWidth 188
#define AttentionItemOrderlabelWidth 12
#define AttentionItemMargin 8
#define AttentionLabelStartX 86
#define BigLabelFont [UIFont systemFontOfSize:22.f]
#define SmallLabelFont [UIFont systemFontOfSize:14.f]
@interface NGHealthReportViewController ()<NGReportNutritonFoodCellDelegate>
{
    BOOL isChinese;
}
@property (nonatomic,assign)BOOL isFirstLoad;
@property (nonatomic,strong)UIImage *selectedImage;
@property (nonatomic,strong)NSArray *illnessArray;
@end

@implementation NGHealthReportViewController
@synthesize lackNutritionArray,potentialArray,attentionDict,isFirstLoad,isFirstSave,recommendFoodDict,dataToSave,selectedImage,illnessArray;
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
-(float)calculateHeightForAttentionPart:(NSArray *)attentionArray
{
    int attentionCount = [attentionArray count];
//    float onelineHeight = [@"o" sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(AttentionItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    float height = 0;
    for (int k = 0; k<attentionCount; k++)
    {
        NSDictionary *anItem = [attentionArray objectAtIndex:k];
        NSString *text;
        if (isChinese)
        {
            text = [anItem objectForKey:@"SuggestionCn"];
        }
        else
        {
            text = [anItem objectForKey:@"SuggestionEn"];
        }
        CGSize textSize = [text sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(AttentionItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
        height+= (textSize.height+AttentionItemMargin);
//        UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(AttentionLabelStartX, attentionStartY, AttentionItemOrderlabelWidth, onelineHeight)];
//        [orderLabel setFont:SmallLabelFont];
//        [orderLabel setText:[NSString stringWithFormat:@"%d.",k+1]];
//        [orderLabel setTextColor:[UIColor blackColor]];
//        UILabel *attentionItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(AttentionLabelStartX+AttentionItemOrderlabelWidth,attentionStartY, textSize.width, textSize.height)];
//        [attentionItemLabel setBackgroundColor:[UIColor clearColor]];
//        [attentionItemLabel setFont:SmallLabelFont];
//        [attentionItemLabel setNumberOfLines:0];
//        [attentionItemLabel setText:text];
//        [attentionItemLabel setTextColor:[UIColor blackColor]];
//        [self.bottomView addSubview:attentionItemLabel];
//        attentionStartY += (textSize.height+AttentionItemMargin);
    }
    height -=AttentionItemMargin;
    return height;

}
-(void)nutritionButtonClicked:(LZCustomDataButton*)sender
{
    NSString *nutritionId = (NSString *)sender.customData;
    NSLog(@"%@",nutritionId);
    LZNutrientionManager *nm = [LZNutrientionManager SharedInstance];
    NSDictionary *dict = [nm getNutritionInfo:nutritionId];
    NSString *captionKey;
    NSString *urlKey;
    //    NSString *descriptionKey;
    if (isChinese)
    {
        captionKey = @"NutrientCnCaption";
        urlKey = @"UrlCn";
        //        descriptionKey = @"NutrientDescription";
    }
    else
    {
        captionKey = @"NutrientEnCaption";
        urlKey = @"UrlEn";
        //        descriptionKey = @"NutrientDescriptionEn";
    }
    NSString *urlString = [dict objectForKey:urlKey];
    //    NSString *description = [dict objectForKey:descriptionKey];
    NSString *nutritionName = [dict objectForKey:captionKey];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGNutritionInfoViewController *nutritionInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGNutritionInfoViewController"];
    nutritionInfoViewController.title =nutritionName;
    nutritionInfoViewController.nutrientDict = dict;
    nutritionInfoViewController.requestUrl =urlString;
    //   nutritionInfoViewController.nutritionDescription = description;
    //    richNutrientController.nutrientDict = dict;
    //    richNutrientController.nutrientTitle = nutritionName;
    //    richNutrientController.nutritionDescription = description;
    [self.navigationController pushViewController:nutritionInfoViewController animated:YES];
}
-(void)illnessButtonClicked:(LZCustomDataButton*)sender
{
    NSIndexPath *illnessIndex = (NSIndexPath *)sender.customData;
    NSDictionary *illnessDict = [self.illnessArray objectAtIndex:illnessIndex.row];
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
    else if (section == 2)
    {
        return  [self.lackNutritionArray count];
    }
    else
    {
        return [self.potentialArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NGReportBMICell *cell = (NGReportBMICell*)[tableView dequeueReusableCellWithIdentifier:@"NGReportBMICell"];
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
        return cell;
    }
    else if (indexPath.section == 1)
    {
        NGReportHealthScoreCell *cell = (NGReportHealthScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"NGReportHealthScoreCell"];
        [cell.backView.layer setBorderColor:BorderColor];
        [cell.backView.layer setBorderWidth:0.5f];
        cell.headerLabel.text = NSLocalizedString(@"jiankangbaogao_c_jiankangzhishu", @"健康指数栏标题：健康指数");
        //12,56,78 3,42,40,20
        NSString *scoreText =[LZUtility getAccurateStringWithDecimal:self.HealthValue];
        CGSize textSize = [scoreText sizeWithFont:[UIFont boldSystemFontOfSize:55.f] constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
        [cell.healthScoreLabel setFrame:CGRectMake(78, 12, textSize.width, 56)];
        [cell.fullPercentLabel setFrame:CGRectMake(78+textSize.width+3, 42, 40, 20)];
        cell.healthScoreLabel.text = scoreText;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        NGReportNutritonFoodCell *cell = (NGReportNutritonFoodCell*)[tableView dequeueReusableCellWithIdentifier:@"NGReportNutritonFoodCell"];
        [cell.backView.layer setBorderColor:BorderColor];
        [cell.backView.layer setBorderWidth:0.5f];
        cell.nutritionHeaderlabel.text = NSLocalizedString(@"jiankangbaogao_c_quefayingyan", @"缺乏营养项标题：缺乏营养");
        cell.foodHeaderLabel.text = NSLocalizedString(@"jiankangbaogao_c_tuijianshiwu", @"推荐食物项标题：推荐食物");
        NSString *nutritionId = [self.lackNutritionArray objectAtIndex:indexPath.row];
        NSArray *recommendFood = [self.recommendFoodDict objectForKey:nutritionId];
        LZNutrientionManager*nm = [LZNutrientionManager SharedInstance];
        NSDictionary *dict = [nm getNutritionInfo:nutritionId];
        //UIColor *backColor = [LZUtility getNutrientColorForNutrientId:nutritionId];
        //NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
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
        //[cell.nutritionNameButton setTitle:nutritionName forState:UIControlStateNormal];
        //cell.nutritionNameButton setba
        [cell.nutritionNameButton setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
        //[cell.nutritionNameButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        //[cell.nutritionNameButton setBackgroundColor:ItemSelectedColor forState:UIControlStateHighlighted];
        //[cell.nutritionNameButton setShowsTouchWhenHighlighted:YES];
        cell.nutritionNameLabel.text = nutritionName;
        [cell.nutritionNameLabel setBackgroundColor:[UIColor clearColor]];
        cell.nutritionNameButton.customData = nutritionId;
        [cell.nutritionNameButton addTarget:self action:@selector(nutritionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //[cell.nutritionNameButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
        //[cell.nutritionNameButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
        [cell setFoods:recommendFood isChinese:isChinese];
        cell.delegate = self;
        cell.cellIndex = indexPath;
        return cell;
    }
    else
    {
        NGReportDiseaseCell *cell = (NGReportDiseaseCell*)[tableView dequeueReusableCellWithIdentifier:@"NGReportDiseaseCell"];
        [cell.backView.layer setBorderColor:BorderColor];
        [cell.backView.layer setBorderWidth:0.5f];
        for (UIView *subv in cell.backView.subviews)
        {
            [subv removeFromSuperview];
        }
        NSString *illnessId = [self.potentialArray objectAtIndex:indexPath.row];
        NSArray *attentionArray = [self.attentionDict objectForKey:illnessId];
        float part2Height = 0;
        BOOL needAddMore;
        if (attentionArray == nil || [attentionArray count]==0)
        {
            if (indexPath.row == [self.potentialArray count]-1)
            {
                [cell.backView setFrame:CGRectMake(10, 0, 300, 60)];
            }
            else
            {
                [cell.backView setFrame:CGRectMake(10, 0, 300, 61)];
            }
            needAddMore = NO;
        }
        else
        {
            part2Height =(int)[self calculateHeightForAttentionPart:attentionArray];
            NSLog(@"cell for cell %d %d %f",indexPath.section,indexPath.row,part2Height);
            if (indexPath.row == [self.potentialArray count]-1)
            {
                [cell.backView setFrame:CGRectMake(10, 0, 300, part2Height+60+10)];
            }
            else
            {
                [cell.backView setFrame:CGRectMake(10, 0, 300, part2Height+60+10+1)];
            }
            needAddMore = YES;
        }
        UILabel *illnessLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 60, 20)];
        [cell.backView addSubview:illnessLabel];
        [illnessLabel setText:NSLocalizedString(@"jiangkangbaogao_c_qianzaishiwu", @"潜在疾病项标题：潜在疾病")];
        [illnessLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0]];
        [illnessLabel setFont:SmallLabelFont];
        UILabel *illnessNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(AttentionLabelStartX, 12, 172, 36)];
        [illnessNameLabel setFont:BigLabelFont];
        [illnessNameLabel setTextColor:[UIColor blackColor]];
        NSDictionary *illnessDict = [self.illnessArray objectAtIndex:indexPath.row];
        NSString *illnessName;
        if (isChinese) {
            illnessName =[illnessDict objectForKey:@"IllnessNameCn"];
        }
        else
        {
            illnessName =[illnessDict objectForKey:@"IllnessNameEn"];
        }

        [illnessNameLabel setText:illnessName];
        [illnessNameLabel setBackgroundColor:[UIColor clearColor]];
        [cell.backView addSubview:illnessNameLabel];
        LZCustomDataButton *illnessButton = [[LZCustomDataButton alloc]initWithFrame:CGRectMake(0, 0, 300, 54)];
        illnessButton.customData =indexPath;
        [illnessButton addTarget:self action:@selector(illnessButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [illnessButton setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
        //[illnessButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        //[illnessButton.titleLabel setFont:BigLabelFont];
        //[illnessButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[illnessButton setTitle:illnessId forState:UIControlStateNormal];
        [cell.backView addSubview:illnessButton];
        UIImageView *detailArrow = [[UIImageView alloc]initWithFrame:CGRectMake(265, 20, 20, 20)];
        [detailArrow setImage:[UIImage imageNamed:@"item_detail_arrow.png"]];
        [cell.backView addSubview:detailArrow];
        if (needAddMore)
        {
            UILabel *attenLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60+(part2Height-20)/2, 60, 20)];
            [cell.backView addSubview:attenLabel];
            [attenLabel setText:NSLocalizedString(@"jiankangbaogao_c_zhuyishixiang", @"注意事项项标题：注意事项")];
            [attenLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0]];
            [attenLabel setFont:SmallLabelFont];
            float onelineHeight = [@"o" sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(AttentionItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
            float startY = 60;
            int attentionCount = [attentionArray count];
            for (int k = 0; k<attentionCount; k++)
            {
                NSDictionary *anItem = [attentionArray objectAtIndex:k];
                NSString *text;
                if (isChinese)
                {
                    text = [anItem objectForKey:@"SuggestionCn"];
                }
                else
                {
                    text = [anItem objectForKey:@"SuggestionEn"];
                }
                CGSize textSize = [text sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(AttentionItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
                UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(AttentionLabelStartX, startY, AttentionItemOrderlabelWidth, onelineHeight)];
                [orderLabel setFont:SmallLabelFont];
                [orderLabel setText:[NSString stringWithFormat:@"%d.",k+1]];
                [orderLabel setTextColor:[UIColor blackColor]];
                [cell.backView addSubview:orderLabel];
                UILabel *attentionItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(AttentionLabelStartX+AttentionItemOrderlabelWidth,startY, textSize.width, textSize.height)];
                [attentionItemLabel setBackgroundColor:[UIColor clearColor]];
                [attentionItemLabel setFont:SmallLabelFont];
                [attentionItemLabel setNumberOfLines:0];
                [attentionItemLabel setText:text];
                [attentionItemLabel setTextColor:[UIColor blackColor]];
                [cell.backView addSubview:attentionItemLabel];
                startY+= (textSize.height+AttentionItemMargin);
            }

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
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 150;
    }
    else if (indexPath.section == 1)
    {
        return 100;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == [self.lackNutritionArray count]-1)
        {
            return 211;
        }
        return 210;
    }
    else
    {
        NSString *illness = [self.potentialArray objectAtIndex:indexPath.row];
        NSArray *attentionArray = [self.attentionDict objectForKey:illness];
        if (attentionArray == nil || [attentionArray count]==0)
        {
            return 60;
        }
        else
        {
            float part2Height =(int)[self calculateHeightForAttentionPart:attentionArray];
            NSLog(@"height for cell %d %d %f",indexPath.section,indexPath.row,part2Height);
            return 60+part2Height +10;
        }
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 0;
    }
    else if (section == 2)
    {
        if ([self.lackNutritionArray count]==0)
        {
            return 0;
        }
        else
        {
            return 20;
        }
    }
    else
    {
        if ([self.potentialArray count] == 0)
        {
            return 0;
        }
        else
        {
            return 20;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return nil;
    }
    else if (section == 2)
    {
        if ([self.lackNutritionArray count]==0)
        {
            return nil;
        }
        else
        {
            UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
            [footer setBackgroundColor:[UIColor clearColor]];
            return footer;
        }
    }
    else
    {
        if ([self.potentialArray count] == 0)
        {
            return nil;
        }
        else
        {
            UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
            [footer setBackgroundColor:[UIColor clearColor]];
            return footer;
        }
    }
}
#pragma mark- NGReportNutritonFoodCellDelegate
-(void)foodClickedForIndex:(NSIndexPath*)index andTag:(int)tag
{
    NSLog(@"section %d  row %d  tag %d",index.section,index.row,tag);
    
    NSString *nutritionId = [self.lackNutritionArray objectAtIndex:index.row];
    NSArray *recommendFood = [self.recommendFoodDict objectForKey:nutritionId];
    NSDictionary *foodAtr = [recommendFood objectAtIndex:tag];
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
