//
//  LZHealthCheckViewController.m
//  nutrition
//
//  Created by liu miao on 9/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZHealthCheckViewController.h"
#import "LZDataAccess.h"
#import "LZUtility.h"
#import "LZDiseaseCell.h"
#import "LZConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "LZRecommendFood.h"
#import "LZCheckResultViewController.h"
#import "MobClick.h"
#import "GADMasterViewController.h"
#import "LZTimeSettingsViewController.h"
@interface LZHealthCheckViewController ()
@property (nonatomic,strong)NSString *sectionTitle;
@property (assign,nonatomic)BOOL isFirstLoad;
@end

@implementation LZHealthCheckViewController
@synthesize diseaseNamesArray,diseasesStateDict,sectionTitle,checkType,isFirstLoad,backWithNoAnimation;
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
    if (ViewControllerUseBackImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    }
    if (backWithNoAnimation)
    {
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
        
    }
    NSString *timeType = [LZUtility getCurrentTimeIdentifier];
    self.checkType = timeType;
    self.diseasesStateDict = [[NSMutableDictionary alloc]init];
    self.diseaseNamesArray = [[NSMutableArray alloc]init];
    self.isFirstLoad = YES;
        //self.questionLabel.text = @"您最近有以下哪些症状?（可多选）";
    UIBarButtonItem *recheckItem = [[UIBarButtonItem alloc]initWithTitle:@"提醒设置" style:UIBarButtonItemStyleBordered target:self action:@selector(timeSettingItemTapped)];
    self.navigationItem.rightBarButtonItem = recheckItem;
    
    UIImage *button30 = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];//stretchableImageWithLeftCapWidth:20 topCapHeight:15];

//    [self.checkItemButton.titleLabel setFont:[UIFont systemFontOfSize:23]];
//    [self.checkItemButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
//    [self.checkItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.checkItemButton setTitle:@"诊断" forState:UIControlStateNormal];
    [self.checkItemButton setBackgroundImage:button30 forState:UIControlStateNormal];

    UIView *admobView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [admobView setBackgroundColor:[UIColor clearColor]];
    self.listView.tableFooterView = admobView;
    
    
}
- (void)cancelButtonTapped
{
    [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:UmengPathJianKangZhenDuan];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];
    [self refreshViewAccordingToTime];
}
-(void)refreshViewAccordingToTime
{
    NSString *timeType = [LZUtility getCurrentTimeIdentifier];
    if (![timeType isEqualToString: checkType] || isFirstLoad)
    {
        checkType = timeType;
        NSDictionary *titleDict = [NSDictionary dictionaryWithObjectsAndKeys:@"从早晨到现在，您有下列哪些状况？",@"上午",@"午饭后到现在，您有下列哪些状况？",@"下午",@"晚饭后到现在，您有下列哪些状况？",@"睡前", nil];
        LZDataAccess *da = [LZDataAccess singleton];
        NSArray *diseaseGroupInfoArray = [da getDiseaseGroupInfo_byType:DiseaseGroupType_DailyDiseaseDiagnose];
        NSArray *groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
        
        self.sectionTitle = [titleDict objectForKey:timeType];
        self.title =[NSString stringWithFormat:@"%@健康诊断",timeType];
        [self.diseaseNamesArray removeAllObjects];
        [self.diseaseNamesArray addObjectsFromArray:[da getDiseaseNamesOfGroup:groupAry[0] andDepartment:nil andDiseaseType:nil andTimeType:timeType]];
        [self.diseasesStateDict removeAllObjects];
        for(NSString *departName in diseaseNamesArray)
        {
            [self.diseasesStateDict setObject:[NSNumber numberWithBool:NO] forKey:departName];
        }
        isFirstLoad = NO;
        [self.listView reloadData];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathJianKangZhenDuan];
}
-(void)timeSettingItemTapped
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZTimeSettingsViewController* timeSettingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZTimeSettingsViewController"];

    [self.navigationController pushViewController:timeSettingsViewController animated:YES];
}
-(IBAction)checkItemTapped:(id)sender
{
    NSMutableArray *userSelectedDiseaseNames = [[NSMutableArray alloc]init];
    for(NSString *departName in diseaseNamesArray)
    {
        NSNumber *checkState = [self.diseasesStateDict objectForKey:departName];

            if ([checkState boolValue])
            {
                [userSelectedDiseaseNames addObject:departName];
            }
    }
    if ([userSelectedDiseaseNames count] == 0)
    {
        UIAlertView *selectEmptyAlert = [[UIAlertView alloc]initWithTitle:nil message:@"恭喜，你现在的身体状况还很健康，在以后的诊断中要继续保持哦！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [selectEmptyAlert show];
        return;
    }
    LZDataAccess *da = [LZDataAccess singleton];
    NSString *text = [userSelectedDiseaseNames componentsJoinedByString:@"；"];
    NSDictionary * nutrientsByDiseaseDict = [da getDiseaseNutrientRows_ByDiseaseNames:userSelectedDiseaseNames andDiseaseGroup:nil];
    
    NSMutableSet *heavySet = [[NSMutableSet alloc]init];
    NSMutableSet *lightSet = [[NSMutableSet alloc]init];
    NSMutableArray *heavyArray = [[NSMutableArray alloc]init];
    NSMutableArray *lightArray = [[NSMutableArray alloc]init];
    
    for (NSString * aDiseaseName in userSelectedDiseaseNames)
    {
        NSArray *relatedNutritionArray = [nutrientsByDiseaseDict objectForKey:aDiseaseName];
        for (NSDictionary * nutritionInfo in relatedNutritionArray)
        {
            NSString *nutritientId = [nutritionInfo objectForKey:@"NutrientID"];
            NSNumber *lackLevel = [nutritionInfo objectForKey:COLUMN_NAME_LackLevelMark];
            if ([lackLevel intValue] == 7)
            {
                [heavySet addObject:nutritientId];
            }
            else
            {
                [lightSet addObject:nutritientId];
            }
        }
    }
    [heavyArray addObjectsFromArray:[heavySet allObjects]];
    NSArray *lightSetArray = [lightSet allObjects];
    for (NSString *nutritientId in lightSetArray)
    {
        if (![heavySet containsObject:nutritientId])
        {
            [lightArray addObject:nutritientId];
        }
    }
    
    NSMutableArray *newPreferArray = [[NSMutableArray alloc]init];
    [newPreferArray addObjectsFromArray:heavyArray];
    [newPreferArray addObjectsFromArray:lightArray];
            
    NSDictionary *emptyIntake = [[NSDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:emptyIntake forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZCheckResultViewController *checkResultViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZCheckResultViewController"];
    checkResultViewController.userSelectedNames = text;
    checkResultViewController.userPreferArray = newPreferArray;
    checkResultViewController.heavylyLackArray = heavyArray;
    checkResultViewController.lightlyLackArray = lightArray;
    checkResultViewController.userTotalScore = 100- 3*[lightArray count]-7*[heavyArray count];
    [self.navigationController pushViewController:checkResultViewController animated:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSString *departmentName = [self.departmentNamesArray objectAtIndex:section];
    //NSMutableArray *stateArray = [self.diseasesStateDict objectForKey:departmentName];
    return [self.diseaseNamesArray count];
    //return [self.nutritionArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZDiseaseCell * cell =(LZDiseaseCell*)[tableView dequeueReusableCellWithIdentifier:@"LZDiseaseCell"];
    NSString *departmentName = [self.diseaseNamesArray objectAtIndex:indexPath.row];
    NSNumber* checkState = [self.diseasesStateDict objectForKey:departmentName];
    [cell.backView.layer setMasksToBounds:YES];
    [cell.backView.layer setCornerRadius:3.0f];
    
    if ([checkState boolValue])
    {
        [cell.stateImageView setImage:[UIImage imageNamed:@"nutrient_button_on.png"]];
    }
    else
    {
        [cell.stateImageView setImage:[UIImage imageNamed:@"nutrient_button_off.png"]];
        
    }
    NSString *onelineStr = @"行";
    CGSize oneSize = [onelineStr sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(260, 9999) lineBreakMode:UILineBreakModeWordWrap];
    CGSize labelSize = [departmentName sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(260, 9999) lineBreakMode:UILineBreakModeWordWrap];
    float height;
    if (labelSize.height > oneSize.height*2 )
    {
        height = labelSize.height+16;
    }
    else
    {
        height = oneSize.height *2+16;
    }
    [cell.backView setFrame:CGRectMake(10, 7, 262,labelSize.height+2)];
    [cell.nameLabel setFrame:CGRectMake(11, 8, 260, labelSize.height)];
    [cell.stateImageView setFrame:CGRectMake(287, (height-8)/2, 22, 18)];
    cell.nameLabel.text = departmentName;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *departmentName = [self.diseaseNamesArray objectAtIndex:indexPath.row];
    NSString *onelineStr = @"行";
    CGSize oneSize = [onelineStr sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(260, 9999) lineBreakMode:UILineBreakModeWordWrap];
    CGSize labelSize = [departmentName sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(260, 9999) lineBreakMode:UILineBreakModeWordWrap];
    if (labelSize.height > oneSize.height*2 )
    {
        return labelSize.height+16;
    }
    else
    {
        return oneSize.height*2+16;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
    [sectionTitleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:sectionTitleLabel];
    
    sectionTitleLabel.text =  self.sectionTitle;
    
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *departmentName = [self.diseaseNamesArray objectAtIndex:indexPath.row];
    NSNumber* checkState = [self.diseasesStateDict objectForKey:departmentName];
    BOOL isOn = [checkState boolValue];
    NSNumber *newState = [NSNumber numberWithBool:!isOn];
    [self.diseasesStateDict setObject:newState forKey:departmentName];
    NSArray *reloadCell = [NSArray arrayWithObject:indexPath];
    [self.listView reloadRowsAtIndexPaths:reloadCell withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [self setCheckItemButton:nil];
    [super viewDidUnload];
}
@end
