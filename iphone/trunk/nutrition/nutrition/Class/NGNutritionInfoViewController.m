//
//  NGNutritionInfoViewController.m
//  nutrition
//
//  Created by liu miao on 12/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGNutritionInfoViewController.h"
#import "LZConstants.h"
#import "LZRecommendFood.h"
#import "NGRecommendFoodView.h"
#import "NGSingleFoodViewController.h"
@interface NGNutritionInfoViewController ()
{
    BOOL isFirstLoad;
    BOOL isChinese;
}
@property (strong,nonatomic)UISegmentedControl *switchViewControl;
@end

@implementation NGNutritionInfoViewController
@synthesize nutrientDict,foodArray,switchViewControl,requestUrl;
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
    isChinese = [LZUtility isCurrentLanguageChinese];
    self.foodArray = [[NSArray alloc]init];
    self.contentScrollView.hidden = YES;
    self.contentWebView.hidden = YES;
    isFirstLoad = YES;
    NSString *tips = [NSString stringWithFormat:NSLocalizedString(@"yingyangsu_header", @"以下是富含%@的食物和每日推荐量"),self.title];
    self.headerLabel.text = [NSString stringWithFormat:@"   %@",tips];
    self.headerLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.headerLabel.layer.borderWidth = 0.5f;
    [self.headerLabel setBackgroundColor:[UIColor colorWithRed:243/255.f green:220/255.f blue:183/255.f alpha:1.0f]];
    switchViewControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [switchViewControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [switchViewControl insertSegmentWithImage:[UIImage imageNamed:@"history.png"] atIndex:0 animated:NO];
    [switchViewControl insertSegmentWithImage:[UIImage imageNamed:@"fork.png"] atIndex:1 animated:NO];
    [switchViewControl setTintColor:[UIColor colorWithRed:6/255.f green:62/255.f blue:4/255.f alpha:1.0f]];
    [switchViewControl addTarget:self action:@selector(switchControlValueChange:) forControlEvents:UIControlEventValueChanged];
    [switchViewControl setSelectedSegmentIndex:1];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:switchViewControl];
    self.navigationItem.rightBarButtonItem = rightItem;


	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    if (isFirstLoad) {
        //self.listView.hidden = YES;
        
        //HUD.labelText = @"智能推荐中...";

        NSURL *url = [NSURL URLWithString:requestUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.contentWebView loadRequest:request];
        
        
        [self performSelector:@selector(loadDataForDisplay) withObject:nil afterDelay:0.f];
    }
}
-(void)switchControlValueChange:(UISegmentedControl*)sender
{
    if (self.switchViewControl.selectedSegmentIndex == 0)
    {
        self.contentWebView.hidden = NO;
        self.contentScrollView.hidden = YES;
    }
    else
    {
        self.contentWebView.hidden = YES;
        self.contentScrollView.hidden = NO;
    }
}
-(void)loadDataForDisplay
{
    NSNumber *planPerson = [NSNumber numberWithInt:1];
    NSNumber *planDays = [NSNumber numberWithInt:1];
    
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
    
    BOOL needConsiderNutrientLoss = Config_needConsiderNutrientLoss;
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss, nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSDictionary *takenFoodAmountDict = [[NSDictionary alloc]init];//[[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
    //    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_AbstractPerson:params withDecidedFoods:takenFoodAmountDict];
    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_withUserInfo:userInfo andDecidedFoods:takenFoodAmountDict andOptions:options];
    
    //NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
    NSString *nutrientId = [self.nutrientDict objectForKey:@"NutrientID"];
    NSDictionary *DRIsDict = [retDict objectForKey:@"DRI"];//nutrient name as key, also column name
    NSDictionary *nutrientInitialSupplyDict = [retDict objectForKey:@"nutrientInitialSupplyDict"];
    NSNumber *nmNutrientInitSupplyVal = [nutrientInitialSupplyDict objectForKey:nutrientId];
    double dNutrientNeedVal = [((NSNumber*)[DRIsDict objectForKey:nutrientId]) doubleValue]*[planPerson intValue]*[planDays intValue];
    double dNutrientLackVal = dNutrientNeedVal - [nmNutrientInitSupplyVal doubleValue];
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *recommendFoodArray = [da getRichNutritionFoodForNutrient:nutrientId andNutrientAmount:[NSNumber numberWithDouble:dNutrientLackVal] andIfNeedCustomDefinedFoods:false];//显示时不用自定义的富含食物清单来限制
    isFirstLoad = NO;
    self.foodArray = [NSArray arrayWithArray:recommendFoodArray];
    int totalFloor = [foodArray count]/3+ (([foodArray count]%3 == 0)?0:1);
    float backHeight = totalFloor*(15+120)+15+30;
    [self.contentScrollView setContentSize:CGSizeMake(320, backHeight+30)];
    [self.backView setFrame:CGRectMake(10, 15, 300, backHeight)];
    [self.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.backView.layer setBorderWidth:0.5f];
    
    float startY = 45;
    int floor = 1;
    int perRowCount = 3;
    float startX;
    for (int i=0; i< [self.foodArray count]; i++)
    {
        
        if (i>=floor *perRowCount)
        {
            floor+=1;
        }
        startX = 10+(i-(floor-1)*perRowCount)*95;
        NSDictionary *foodInfo = [foodArray objectAtIndex:i];
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
        NSString *foodQueryKey;
        if (isChinese)
        {
            foodQueryKey = @"CnCaption";
        }
        else
        {
            foodQueryKey = @"FoodNameEn";
        }
        NSString *foodName = [foodInfo objectForKey:foodQueryKey];
        
        NSNumber *weight = [foodInfo objectForKey:@"FoodAmount"];
        //cell.foodUnitLabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
        //NSDictionary *foodAtr = [allFoodUnitDict objectForKey:foodId];
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
        NGRecommendFoodView *foodView = [[NGRecommendFoodView alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*135, 80, 120) foodName:foodName foodPic:picturePath foodAmount:foodTotalUnit];
        foodView.touchButton.tag = 10+i;
        [foodView.touchButton addTarget:self action:@selector(foodClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backView addSubview:foodView];
    }
    self.contentScrollView.hidden = NO;
//    [self.listView reloadData];
//    [HUD hide:YES];
//    self.listView.hidden = NO;
}
-(void)foodClicked:(UIButton*)sender
{
    //NGRecommendFoodView *foodView = (NGRecommendFoodView *)sender.view;
    
    int tag = sender.tag-10;
    NSDictionary *foodInfo = [foodArray objectAtIndex:tag];
    NSLog(@"%@",foodInfo);
    NSString *foodQueryKey;
    if (isChinese)
    {
        foodQueryKey = @"CnCaption";
    }
    else
    {
        foodQueryKey = @"FoodNameEn";
    }
    NSString *foodName = [foodInfo objectForKey:foodQueryKey];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGSingleFoodViewController *singleFoodViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGSingleFoodViewController"];
    singleFoodViewController.title = foodName;
    singleFoodViewController.foodInfoDict = foodInfo;
    [self.navigationController pushViewController:singleFoodViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
