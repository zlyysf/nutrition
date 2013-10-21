//
//  LZNutritionListViewController.m
//  nutrition
//
//  Created by liu miao on 8/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutritionListViewController.h"
#import "LZRecommendFood.h"
#import "LZRichNutritionViewController.h"
#import "LZConstants.h"
#import "MobClick.h"
#import "LZUtility.h"
#import "GADMasterViewController.h"
#import "LZNutritionButton.h"
#import "LZNutrientionManager.h"
@interface LZNutritionListViewController ()
{
    BOOL isChinese;
}
@property (assign,nonatomic)BOOL isFirstLoad;
@end

@implementation LZNutritionListViewController
@synthesize nutritionArray,isFirstLoad,admobView;
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
    self.title = NSLocalizedString(@"nutritionlist_viewtitle",@"营养");
    if (ViewControllerUseBackImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    }
    if([LZUtility isCurrentLanguageChinese])
    {
        isChinese = YES;
    }
    else
    {
        isChinese = NO;
    }
    nutritionArray = [LZRecommendFood getCustomNutrients:nil];
    isFirstLoad = YES;
    int totalFloor = [nutritionArray count]/3+ (([nutritionArray count]%3 == 0)?0:1);
    float scrollHeight = totalFloor *94 + 20+ (totalFloor-1)*8+50;
    self.admobView = [[UIView alloc]initWithFrame:CGRectMake(0, scrollHeight-50, 320, 50)];
    [self.listView addSubview:self.admobView];
    [self.listView setContentSize:CGSizeMake(320, scrollHeight)];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:UmengPathYingYangYuanSu];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        [self setButtons];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathYingYangYuanSu];
}
-(void)setButtons
{
    float startY = 10;
    int floor = 1;
    int perRowCount = 3;
    float startX;
    for (int i=0; i< [self.nutritionArray count]; i++)
    {
        
        if (i>=floor *perRowCount)
        {
            floor+=1;
        }
        startX = 10+(i-(floor-1)*perRowCount)*102;
        NSString *nutritionId = [self.nutritionArray objectAtIndex:i];
        LZNutrientionManager*nm = [LZNutrientionManager SharedInstance];
        NSDictionary *dict = [nm getNutritionInfo:nutritionId];
        UIColor *backColor = [LZUtility getNutrientColorForNutrientId:nutritionId];
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
        NSDictionary *info = [LZUtility getNutritionNameInfo:nutritionName];
        UIImage*backImage = [LZUtility createImageWithColor:backColor imageSize:CGSizeMake(94, 94)];
        LZNutritionButton *button = [[LZNutritionButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*102, 94, 94) info:info image:backImage];
        [self.listView addSubview:button];
        //[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_button.png",nutritionId]] forState:UIControlStateNormal];
        button.tag = i+100;
        [button addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)typeButtonTapped:(UIButton *)sender
{
    int tag = sender.tag -100;
    NSDictionary *emptyIntake = [[NSDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:emptyIntake forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *nutritionId = [self.nutritionArray objectAtIndex:tag];
    LZNutrientionManager *nm = [LZNutrientionManager SharedInstance];
    NSDictionary *dict = [nm getNutritionInfo:nutritionId];
    NSString *queryKey;
    if (isChinese)
    {
        queryKey = @"NutrientCnCaption";
    }
    else
    {
        queryKey = @"NutrientEnCaption";
    }

    //NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
    NSString *nutritionName = [dict objectForKey:queryKey];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZRichNutritionViewController *addByNutrientController = [storyboard instantiateViewControllerWithIdentifier:@"LZRichNutritionViewController"];
    addByNutrientController.nutrientDict = dict;
    addByNutrientController.nutrientTitle = nutritionName;
    [self.navigationController pushViewController:addByNutrientController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [self setListView:nil];
    [super viewDidUnload];
}
@end
