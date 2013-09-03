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
@interface LZHealthCheckViewController ()

@end

@implementation LZHealthCheckViewController
@synthesize departmentNamesArray,diseasesStateDict;
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
    self.title = @"健康诊断";
    self.diseasesStateDict = [[NSMutableDictionary alloc]init];
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *diseaseGroupInfoArray = [da getDiseaseGroupInfo_byType:DiseaseGroupType_discomfort];
    NSArray *groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
    NSString *illnessGroup = groupAry[0];
    NSDictionary *info = [da getDiseasesOrganizedByDepartment_OfGroup:illnessGroup];
    NSLog(@"%@",info);
    self.departmentNamesArray = [info objectForKey:@"departmentNames"];
    NSDictionary * departmentDiseasesDict = [info objectForKey:@"departmentDiseasesDict"];
    for(NSString *departName in departmentNamesArray)
    {
        NSArray *diseaseArray = [departmentDiseasesDict objectForKey:departName];
        NSMutableArray *stateArray = [[NSMutableArray alloc]init];
        for (NSString *diseaseName in diseaseArray)
        {
            NSArray *array = [NSArray arrayWithObjects:diseaseName,[NSNumber numberWithBool:NO], nil];
            [stateArray addObject:array];
        }
        [self.diseasesStateDict setObject:stateArray forKey:departName];
    }
    self.questionLabel.text = @"您最近有以下哪些症状?（可多选）";
    UIBarButtonItem *recheckItem = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(recheckItemTapped)];
    self.navigationItem.rightBarButtonItem = recheckItem;
    UIImage *button30 = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:checkButton];
    [checkButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [checkButton setFrame:CGRectMake(10, 10, 300, 30)];
    [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkButton setTitle:@"诊    断" forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkItemTapped) forControlEvents:UIControlEventTouchUpInside];
    [checkButton setBackgroundImage:button30 forState:UIControlStateNormal];
    self.listView.tableFooterView = footerView;
}
-(void)recheckItemTapped
{
    for(NSString *departName in departmentNamesArray)
    {
        NSMutableArray *stateArray = [self.diseasesStateDict objectForKey:departName];
        for(int i = 0;i< [stateArray count];i++)
        {
            NSArray *state = [stateArray objectAtIndex:i];
            NSString *diseaseName = [state objectAtIndex:0];
            NSNumber *newState = [NSNumber numberWithBool:NO];
            NSArray *newArray = [NSArray arrayWithObjects:diseaseName,newState, nil];
            [stateArray replaceObjectAtIndex:i withObject:newArray];
        }
    }
    [self.listView reloadData];
    [self.listView setContentOffset:CGPointMake(0, 0) animated:YES];

}
-(void)checkItemTapped
{
    NSMutableArray *userSelectedDiseaseNames = [[NSMutableArray alloc]init];
    for(NSString *departName in departmentNamesArray)
    {
        NSMutableArray *stateArray = [self.diseasesStateDict objectForKey:departName];
        for(int i = 0;i< [stateArray count];i++)
        {
            NSArray *state = [stateArray objectAtIndex:i];
            NSString *diseaseName = [state objectAtIndex:0];
            NSNumber *checkState = [state objectAtIndex:1];
            if ([checkState boolValue])
            {
                [userSelectedDiseaseNames addObject:diseaseName];
            }
        }
    }
    if ([userSelectedDiseaseNames count] == 0)
    {
        UIAlertView *selectEmptyAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有选择任何不适症状，请至少选择一项以便进行诊断。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [selectEmptyAlert show];
        return;
    }
    LZDataAccess *da = [LZDataAccess singleton];
    NSString *text = [userSelectedDiseaseNames componentsJoinedByString:@"、"];
    NSDictionary * nutrientsByDiseaseDict = [da getDiseaseNutrients_ByDiseaseNames:userSelectedDiseaseNames];
    
    NSMutableSet * nutrientSet = [NSMutableSet setWithCapacity:100];
    for ( NSString* key in nutrientsByDiseaseDict) {
        NSArray *nutrients = nutrientsByDiseaseDict[key];
        [nutrientSet addObjectsFromArray:nutrients];
        }
    NSArray *customNutrients = [LZRecommendFood getCustomNutrients:nil];
    NSArray *newPreferArray = [LZUtility arrayIntersectSet_withArray:[NSMutableArray arrayWithArray:customNutrients] andSet:nutrientSet];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZCheckResultViewController *checkResultViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZCheckResultViewController"];
    checkResultViewController.userSelectedNames = text;
    checkResultViewController.userPreferArray = newPreferArray;
    [self.navigationController pushViewController:checkResultViewController animated:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *departmentName = [self.departmentNamesArray objectAtIndex:section];
    NSMutableArray *stateArray = [self.diseasesStateDict objectForKey:departmentName];
    return [stateArray count];
    //return [self.nutritionArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZDiseaseCell * cell =(LZDiseaseCell*)[tableView dequeueReusableCellWithIdentifier:@"LZDiseaseCell"];
    NSString *departmentName = [self.departmentNamesArray objectAtIndex:indexPath.section];
    NSMutableArray *stateArray = [self.diseasesStateDict objectForKey:departmentName];
    NSArray *state = [stateArray objectAtIndex:indexPath.row];
    NSString *diseaseName = [state objectAtIndex:0];
    NSNumber *checkState = [state objectAtIndex:1];
    [cell.backView.layer setMasksToBounds:YES];
    [cell.backView.layer setCornerRadius:3.0f];
    cell.nameLabel.text = diseaseName;
    cell.stateImageView.hidden = ![checkState boolValue];
    if (indexPath.row == [stateArray count]-1)
    {
        cell.sepratorLine.hidden = YES;
    }
    else
    {
        cell.sepratorLine.hidden = NO;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    [sectionTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:sectionTitleLabel];
    
    sectionTitleLabel.text =  [self.departmentNamesArray objectAtIndex:section];
    
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.departmentNamesArray count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *departmentName = [self.departmentNamesArray objectAtIndex:indexPath.section];
    NSMutableArray *stateArray = [self.diseasesStateDict objectForKey:departmentName];
    NSArray *state = [stateArray objectAtIndex:indexPath.row];
    NSString *diseaseName = [state objectAtIndex:0];
    NSNumber *checkState = [state objectAtIndex:1];
    BOOL isOn = [checkState boolValue];
    NSNumber *newState = [NSNumber numberWithBool:!isOn];
    NSArray *newArray = [NSArray arrayWithObjects:diseaseName,newState, nil];
    [stateArray replaceObjectAtIndex:indexPath.row withObject:newArray];
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
    [self setQuestionLabel:nil];
    [super viewDidUnload];
}
@end
