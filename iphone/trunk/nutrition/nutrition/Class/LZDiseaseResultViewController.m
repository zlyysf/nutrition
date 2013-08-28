//
//  LZDiseaseResultViewController.m
//  nutrition
//
//  Created by liu miao on 8/28/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDiseaseResultViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LZConstants.h"
#import "LZUserDietListViewController.h"
#import "LZDietListMakeViewController.h"
#import "LZMainPageViewController.h"
#import "LZDataAccess.h"
#import "LZUtility.h"
#import "LZRecommendFood.h"
#import "LZNutrientionManager.h"
#import "MBProgressHUD.h"
#import "LZReviewAppManager.h"
@interface LZDiseaseResultViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@end

@implementation LZDiseaseResultViewController
@synthesize relatedNutritionArray,displayAreaHeight,maxNutrientCount;
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
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"  返回" forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 48, 30);
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = cancelItem;
    NSString *list_bg_path = [[NSBundle mainBundle] pathForResource:@"table_list_bg@2x" ofType:@"png"];
    UIImage * list_bg_image = [UIImage imageWithContentsOfFile:list_bg_path];
    UIImage *list_bg = [list_bg_image resizableImageWithCapInsets:UIEdgeInsetsMake(20,10,20,10)];
    [self.backImageView setImage:list_bg];
    [self.resultView.layer setMasksToBounds:YES];
    [self.resultView.layer setCornerRadius:5];
    [self.resultView setBackgroundColor:[UIColor clearColor]];
    UIImage *button_back_img = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.recommendFoodButton setBackgroundImage:button_back_img forState:UIControlStateNormal];
    NSArray *customNutrients = [LZRecommendFood getCustomNutrients:nil];
    maxNutrientCount = [customNutrients count];
}
-(void)cancelButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)recommendFoodButtonTapped:(id)sender {
    HUD.hidden = NO;
    [HUD show:YES];
    //self.listView.hidden = YES;
    
    HUD.labelText = @"智能推荐中...";
    
    [self performSelector:@selector(recommendOnePlan) withObject:nil afterDelay:0.f];
}
- (void)recommendOnePlan
{
    NSArray *preferNutrient = [[NSUserDefaults standardUserDefaults]objectForKey:KeyUserRecommendPreferNutrientArray];
    NSSet *selectNutrient = [NSSet setWithArray:self.relatedNutritionArray];
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
    
    [userDefaults setObject:newPreferArray forKey:KeyUserRecommendPreferNutrientArray];
    [userDefaults setObject:recommendFoodAmountDict forKey:LZUserDailyIntakeKey];
    [userDefaults synchronize];
    
    [HUD hide:YES];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZUserDietListViewController *userDietListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZUserDietListViewController"];
    userDietListViewController.backWithNoAnimation = YES;
    LZMainPageViewController *mainPageViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZMainPageViewController"];
    LZDietListMakeViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietListMakeViewController"];
    foodListViewController.listType = dietListTypeNew;
    foodListViewController.useRecommendNutrient = YES;
    foodListViewController.backWithNoAnimation = YES;
    foodListViewController.title = @"推荐的食物";
    NSArray *vcs = [NSArray arrayWithObjects:mainPageViewController,userDietListViewController,foodListViewController, nil];
    [self.navigationController setViewControllers:vcs animated:YES];
    [[LZReviewAppManager SharedInstance]popReviewOurAppAlertAccordingRules];
}

-(void)viewWillAppear:(BOOL)animated
{
    displayAreaHeight = self.resultView.frame.size.height-139;
    [self displayResult];
}
-(void)clearResultView
{
    for (UIView *sv in self.resultView.subviews)
    {
        if ([sv isKindOfClass:[UIButton class]])
        {
            if (sv.tag >=101 && sv.tag <= 100+maxNutrientCount)
            {
                [sv removeFromSuperview];
            }
        }
    }
}

-(void)displayResult
{
    [self clearResultView];
    int totalFloor = [relatedNutritionArray count]/4+ (([relatedNutritionArray count]%4 == 0)?0:1);
    float resultLabelDisplayMaxArea = displayAreaHeight-totalFloor*40-28;
    CGSize labelSize = [@"暂无" sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap];
    LZDataAccess *da = [LZDataAccess singleton];
    float labelHeight = (labelSize.height > resultLabelDisplayMaxArea ? resultLabelDisplayMaxArea:labelSize.height);
    self.diseaseInfoLabel.frame = CGRectMake(10, 38, 280, labelHeight);
    self.diseaseInfoLabel.text = @"暂无";
    CGRect nutrientFrame = self.nutrientLabel.frame;
    nutrientFrame.origin.y   = 38+labelHeight+10;
    self.nutrientLabel.frame = nutrientFrame;
    
    float startY = 38+labelHeight+10+18+10;
    int floor = 1;
    int countPerRow = 4;
    float startX;
    for (int i = 0; i< [relatedNutritionArray count];i++)
    {
        if (i>=floor *countPerRow)
        {
            floor+=1;
        }
        startX = 10+(i-(floor-1)*countPerRow)*73;
        UIButton *nutrientButton = [[UIButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*40, 63, 30)];
        [self.resultView addSubview:nutrientButton];
        nutrientButton.tag = 101+i;
        [nutrientButton addTarget:self action:@selector(nutrientButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        NSString *key = [relatedNutritionArray objectAtIndex:i];
        NSDictionary *dict = [da getNutrientInfo:key];
        NSString *name = [dict objectForKey:@"NutrientCnCaption"];
        [nutrientButton setTitle:name forState:UIControlStateNormal];
        [nutrientButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:key];
        [nutrientButton setBackgroundColor:fillColor];
        [nutrientButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [nutrientButton.layer setCornerRadius:5];
        [nutrientButton.layer setMasksToBounds:YES];
    }
}
-(void)nutrientButtonTapped:(UIButton *)nutrientButton
{
    int tag = nutrientButton.tag-101;
    NSString *key = [relatedNutritionArray objectAtIndex:tag];
    [[LZNutrientionManager SharedInstance]showNutrientInfo:key];
}
- (void)viewDidUnload {
    [self setDiseaseInfoLabel:nil];
    [self setNutrientLabel:nil];
    [self setRecommendFoodButton:nil];
    [self setBackImageView:nil];
    [self setResultView:nil];
    [super viewDidUnload];
}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    HUD.hidden = YES;
}
@end
