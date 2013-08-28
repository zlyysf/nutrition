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
@interface LZDiseaseResultViewController ()

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
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //    LZDietPickerViewController * dietPickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietPickerViewController"];
    //    dietPickerViewController.recommendNutritionArray = orderedNutrientsInSet;
    //    [self.navigationController pushViewController:dietPickerViewController animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZUserDietListViewController *userDietListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZUserDietListViewController"];
    userDietListViewController.backWithNoAnimation = YES;
    LZMainPageViewController *mainPageViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZMainPageViewController"];
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
    [[NSUserDefaults standardUserDefaults]setObject:newPreferArray forKey:KeyUserRecommendPreferNutrientArray];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    LZDietListMakeViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietListMakeViewController"];
    foodListViewController.listType = dietListTypeNew;
    foodListViewController.useRecommendNutrient = YES;
    foodListViewController.backWithNoAnimation = YES;
    foodListViewController.title = @"推荐的食物";
    NSArray *vcs = [NSArray arrayWithObjects:mainPageViewController,userDietListViewController,foodListViewController, nil];
    [self.navigationController setViewControllers:vcs animated:YES];
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

@end
