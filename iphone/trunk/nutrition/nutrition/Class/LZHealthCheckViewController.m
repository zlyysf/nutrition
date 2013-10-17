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
#import "LZCheckTypeSwitchView.h"
#define DiagnosticLabelLength 245.f
@interface LZHealthCheckViewController ()<LZCheckTypeSwitchViewDelegate>
{
    BOOL isChinese;
}
@property (nonatomic,strong)NSString *sectionTitle;
@property (assign,nonatomic)BOOL isFirstLoad;
@property (assign,nonatomic)BOOL pushToNextView;
@end

@implementation LZHealthCheckViewController
@synthesize diseaseNamesArray,diseasesStateDict,sectionTitle,checkType,isFirstLoad,backWithNoAnimation,pushToNextView,headerDict,diseaseIdsArray;
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
//    if (backWithNoAnimation)
//    {
        UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"fanhuibutton",@"  返回") forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0, 0, 48, 30);
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [button addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = cancelItem;
        
    //}
    NSString *timeType = [LZUtility getCurrentTimeIdentifier];
    self.checkType = timeType;
    self.diseasesStateDict = [[NSMutableDictionary alloc]init];
    self.diseaseNamesArray = [[NSMutableArray alloc]init];
    self.diseaseIdsArray = [[NSMutableArray alloc]init];
    self.isFirstLoad = YES;
        //self.questionLabel.text = @"您最近有以下哪些症状?（可多选）";
    UIBarButtonItem *recheckItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"tixingshezhibutton",@"提醒设置") style:UIBarButtonItemStyleBordered target:self action:@selector(timeSettingItemTapped)];
    self.navigationItem.rightBarButtonItem = recheckItem;   
    UIImage *button30 = [[UIImage imageNamed:@"button_back_40"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.checkItemButton setBackgroundImage:button30 forState:UIControlStateNormal];
    [self.checkItemButton setTitle:NSLocalizedString(@"zhenduanbutton",@"诊断") forState:UIControlStateNormal];
    float indicatorX;
    float fontSize;
    if ([LZUtility isCurrentLanguageChinese])
    {
        indicatorX = 140;
        fontSize = 20;
        isChinese = YES;
        [self.checkItemButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    else
    {
        indicatorX = 180;
        fontSize =  18;
        isChinese = NO;
        [self.checkItemButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }

    UIView *topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    [topBarView setBackgroundColor:[UIColor clearColor]];
    UILabel *topTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 7, 175, 30)];
    [topTitleLabel setShadowOffset:CGSizeMake(0, -1)];
    [topTitleLabel setShadowColor:[UIColor darkGrayColor]];
    [topTitleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [topTitleLabel setTextColor:[UIColor whiteColor]];
    [topTitleLabel setBackgroundColor:[UIColor clearColor]];
    topTitleLabel.textAlignment = UITextAlignmentCenter;
    topTitleLabel.tag = 20;
    [topBarView addSubview:topTitleLabel];
        
    UIImageView *switchIndicatorView = [[UIImageView alloc]initWithFrame:CGRectMake(indicatorX, 18, 12, 12)];
    [switchIndicatorView setImage:[UIImage imageNamed:@"arrow_down.png"]];
    switchIndicatorView.tag = 21;
    [topBarView addSubview:switchIndicatorView];
    UIButton *switchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    [switchButton addTarget:self action:@selector(switchTapped) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:switchButton];
    self.navigationItem.titleView = topBarView;
    UIView *admobView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    [admobView setBackgroundColor:[UIColor clearColor]];
    self.listView.tableFooterView = admobView;
    headerDict = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"healthcheck_headercontent0",@"从早晨到现在，您有下列哪些状况？"),@"上午",NSLocalizedString(@"healthcheck_headercontent1",@"午饭后到现在，您有下列哪些状况？"),@"下午",NSLocalizedString(@"healthcheck_headercontent2",@"晚饭后到现在，您有下列哪些状况？"),@"睡前", nil];
}
-(void)switchTapped
{
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    UIView *topbarView = self.navigationItem.titleView;
    UIImageView *switchIndicatorView = (UIImageView *)[topbarView viewWithTag:21];
    [switchIndicatorView setImage:[UIImage imageNamed:@"arrow_up.png"]];
    NSArray *array = [NSArray arrayWithObjects:@"上午",@"下午",@"睡前", nil];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:array,@"buttonTitles",checkType,@"currentType", nil];
    LZCheckTypeSwitchView *switchView = [[LZCheckTypeSwitchView alloc]initWithFrame:CGRectMake(0, 20, screenSize.width, screenSize.height-20) andInfo:dict delegate:self];
    [self.navigationController.view addSubview:switchView];
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
    if (isFirstLoad)
    {
        [self refreshViewAccordingToTime:checkType];
    }
    if (pushToNextView)
    {
        pushToNextView = NO;
        [self resetPage];
    }

}
-(void)resetPage
{
    for(NSString *departName in diseaseNamesArray)
    {
        [self.diseasesStateDict setObject:[NSNumber numberWithBool:NO] forKey:departName];
    }
    [self.listView reloadData];
    [self.listView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)refreshViewAccordingToTime:(NSString *)timeType
{
    checkType = timeType;
    self.sectionTitle = [headerDict objectForKey:timeType];
    UIView *topbarView = self.navigationItem.titleView;
    UILabel *topbarLabel = (UILabel *)[topbarView viewWithTag:20];
    NSDictionary *titleDict = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"healthcheck_viewtitle0",@"上午诊断"),@"上午",NSLocalizedString(@"healthcheck_viewtitle1",@"下午诊断"),@"下午",NSLocalizedString(@"healthcheck_viewtitle2",@"睡前诊断"),@"睡前", nil];
    [topbarLabel setText:[titleDict objectForKey:timeType]];

    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *diseaseGroupInfoArray = [da getDiseaseGroupInfo_byType:DiseaseGroupType_DailyDiseaseDiagnose];
    NSArray *groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
    NSString *illnessGroup = groupAry[0];
    NSArray *idArray = [da getDiseaseIdsOfGroup:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:timeType];
    [self.diseaseIdsArray removeAllObjects];
    [self.diseaseIdsArray addObjectsFromArray:idArray];
    NSArray *diseaseInfoAry = [da getDiseaseInfosOfGroup:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:nil];
    NSDictionary *diseaseInfo2LevelDict = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:COLUMN_NAME_Disease andDicArray:diseaseInfoAry];
    NSString *queryKey;
    if (isChinese)
    {
        queryKey = @"Disease";
    }
    else
    {
        queryKey = @"DiseaseEn";
    }
    [self.diseaseNamesArray removeAllObjects];
    [self.diseasesStateDict removeAllObjects];
    for (NSString *diseaseId in self.diseaseIdsArray)
    {
        NSDictionary *diseaseInfo = [diseaseInfo2LevelDict objectForKey:diseaseId];
        NSString *diseaseName = [diseaseInfo objectForKey:queryKey];
        [self.diseaseNamesArray addObject:diseaseName];
        [self.diseasesStateDict setObject:[NSNumber numberWithBool:NO] forKey:diseaseName];
        
    }
    isFirstLoad = NO;
    [self.listView reloadData];
    [self.listView setContentOffset:CGPointMake(0, 0) animated:YES];
    
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
    
    [MobClick event:UmengEventZhenDuan];
    NSMutableArray *userSelectedDiseaseNames = [[NSMutableArray alloc]init];
    NSMutableArray *userSelectedDiseaseIds = [[NSMutableArray alloc]init];
    for(int i = 0;i< [self.diseaseNamesArray count];i++)
    {
        NSString *departName  =  [diseaseNamesArray objectAtIndex:i];
        NSNumber *checkState = [self.diseasesStateDict objectForKey:departName];

            if ([checkState boolValue])
            {
                [userSelectedDiseaseIds addObject:[self.diseaseIdsArray objectAtIndex:i]];
                [userSelectedDiseaseNames addObject:departName];
            }
    }
    if ([userSelectedDiseaseNames count] == 0)
    {
        UIAlertView *selectEmptyAlert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"heathcheck_alert0_title",@"恭喜，你现在的身体状况还很健康，在以后的诊断中要继续保持哦！") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
        [selectEmptyAlert show];
        return;
    }
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *diseaseGroupInfoArray;
    NSArray *groupAry;
    NSString *illnessGroup;
    diseaseGroupInfoArray= [da getDiseaseGroupInfo_byType:DiseaseGroupType_DailyDiseaseDiagnose];
    groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
    illnessGroup = groupAry[0];
    NSString *text = [userSelectedDiseaseNames componentsJoinedByString:@"; "];
    NSDictionary * nutrientsByDiseaseDict = [da getDiseaseNutrientRows_ByDiseaseIds:userSelectedDiseaseIds andDiseaseGroup:illnessGroup];
    
    NSMutableSet *heavySet = [[NSMutableSet alloc]init];
    NSMutableSet *lightSet = [[NSMutableSet alloc]init];
    NSMutableArray *heavyArray = [[NSMutableArray alloc]init];
    NSMutableArray *lightArray = [[NSMutableArray alloc]init];
    
    for (NSString * aDiseaseName in userSelectedDiseaseIds)
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
    self.pushToNextView = YES;
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
    //[cell.backView.layer setMasksToBounds:YES];
    //[cell.backView.layer setCornerRadius:3.0f];
    
    if ([checkState boolValue])
    {
        [cell.stateImageView setImage:[UIImage imageNamed:@"cell_check_on.png"]];
    }
    else
    {
        [cell.stateImageView setImage:[UIImage imageNamed:@"cell_check_off.png"]];
        
    }
    NSString *onelineStr = @"1";
    CGSize oneSize = [onelineStr sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(DiagnosticLabelLength, 9999) lineBreakMode:UILineBreakModeWordWrap];
    CGSize labelSize = [departmentName sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(DiagnosticLabelLength, 9999) lineBreakMode:UILineBreakModeWordWrap];
    float height;
    if (labelSize.height > oneSize.height*2 )
    {
        height = labelSize.height;
        //[cell.backView setFrame:CGRectMake(10, 9, DiagnosticLabelLength+2,height+2)];
        [cell.nameLabel setFrame:CGRectMake(11, 10, DiagnosticLabelLength, height)];
        [cell.stateImageView setFrame:CGRectMake(270, (height+20-31)/2, 40, 31)];
    }
    else
    {
        height = oneSize.height *2;
        //[cell.backView setFrame:CGRectMake(10, 14, DiagnosticLabelLength+2,height+2)];
        [cell.nameLabel setFrame:CGRectMake(11, 15, DiagnosticLabelLength, height)];
        [cell.stateImageView setFrame:CGRectMake(270, (height+30-31)/2, 40, 31)];
    }

    cell.nameLabel.text = departmentName;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *departmentName = [self.diseaseNamesArray objectAtIndex:indexPath.row];
    NSString *onelineStr = @"1";
    CGSize oneSize = [onelineStr sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(DiagnosticLabelLength, 9999) lineBreakMode:UILineBreakModeWordWrap];
    CGSize labelSize = [departmentName sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(DiagnosticLabelLength, 9999) lineBreakMode:UILineBreakModeWordWrap];
    if (labelSize.height > oneSize.height*2)
    {
        return labelSize.height+20;
    }
    else
    {
        return oneSize.height*2+30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *onelineStr = @"1";
    CGSize oneSize = [onelineStr sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(305, 9999) lineBreakMode:UILineBreakModeWordWrap];
    CGSize labelSize = [self.sectionTitle sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(305, 9999) lineBreakMode:UILineBreakModeWordWrap];
    if(labelSize.height > oneSize.height)
    {
        return labelSize.height +10;
    }
    else
    {
        return 27;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float secHeight;
    NSString *onelineStr = @"1";
    CGSize oneSize = [onelineStr sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(305, 9999) lineBreakMode:UILineBreakModeWordWrap];
    CGSize labelSize = [self.sectionTitle sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(305, 9999) lineBreakMode:UILineBreakModeWordWrap];
    if(labelSize.height > oneSize.height)
    {
        secHeight = labelSize.height +10;
    }
    else
    {
       secHeight = 27;
    }

    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, secHeight)];
    UIImageView *sectionBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, secHeight)];
    [sectionView addSubview:sectionBarView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"section_bar@2x" ofType:@"png"];
    UIImage * sectionBarImage = [UIImage imageWithContentsOfFile:path];
    UIImage *strechImage = [sectionBarImage stretchableImageWithLeftCapWidth:0 topCapHeight:5];
    [sectionBarView setImage:strechImage];
    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 305, labelSize.height)];
    [sectionTitleLabel setNumberOfLines:0];
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
    [self.listView reloadRowsAtIndexPaths:reloadCell withRowAnimation:UITableViewRowAnimationNone];

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
- (void)switchViewClosed:(LZCheckTypeSwitchView *)switchView
{
    UIView *topbarView = self.navigationItem.titleView;
    UIImageView *switchIndicatorView = (UIImageView *)[topbarView viewWithTag:21];
    [switchIndicatorView setImage:[UIImage imageNamed:@"arrow_down.png"]];
    if(switchView.superview )
    {
        [switchView removeFromSuperview];
    }
}
- (void)switchViewSubmitted:(LZCheckTypeSwitchView *)switchView selection:(NSString *)type
{
    UIView *topbarView = self.navigationItem.titleView;
    UIImageView *switchIndicatorView = (UIImageView *)[topbarView viewWithTag:21];
    [switchIndicatorView setImage:[UIImage imageNamed:@"arrow_down.png"]];
    if(switchView.superview )
    {
        [switchView removeFromSuperview];
    }
    [self refreshViewAccordingToTime:type];
}
@end
