//
//  LZDiseasePreventViewController.m
//  nutrition
//
//  Created by liu miao on 8/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDiseasePreventViewController.h"
#import "LZDataAccess.h"
#import "LZUtility.h"
#import "LZConstants.h"
#import "LZDiseaseCell.h"
#import "LZRecommendFood.h"
#import "LZDiseaseResultViewController.h"
@interface LZDiseasePreventViewController ()

@end

@implementation LZDiseasePreventViewController
@synthesize isSecondClass,diseaseNameLevel1Array,diseaseNameLevel2Array,diseaseNameDict;
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
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
    if (!isSecondClass)
    {
        self.title = @"预防疾病";
        LZDataAccess *da = [LZDataAccess singleton];
        NSArray *diseaseGroupInfoArray = [da getDiseaseGroupInfo_byType:DiseaseGroupType_illness];
        NSArray *groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
        NSString *illnessGroup = groupAry[0];
        NSDictionary *groupDict = [da getDiseasesOrganizedByDepartment_OfGroup:illnessGroup];
        self.diseaseNameLevel1Array = [groupDict objectForKey:@"departmentNames"];
        self.diseaseNameDict = [groupDict objectForKey:@"departmentDiseasesDict"];
    }
    
}
-(void)backButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
#pragma mark- TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!isSecondClass) {
        return [self.diseaseNameLevel1Array count];
    }
    return [self.diseaseNameLevel2Array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *diseaseName;
    if (!isSecondClass)
    {
        diseaseName = [self.diseaseNameLevel1Array objectAtIndex:indexPath.row];
    }
    else
    {
        diseaseName = [self.diseaseNameLevel2Array objectAtIndex:indexPath.row];
    }
    LZDiseaseCell * cell =(LZDiseaseCell*)[tableView dequeueReusableCellWithIdentifier:@"LZDiseaseCell"];
    cell.diseaseNameLabel.text = diseaseName;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if (!isSecondClass)
    {
        NSString* diseaseName = [self.diseaseNameLevel1Array objectAtIndex:indexPath.row];
        
        LZDiseasePreventViewController *diseasePreventViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDiseasePreventViewController"];
        diseasePreventViewController.diseaseNameLevel2Array = [self.diseaseNameDict objectForKey:diseaseName];
        diseasePreventViewController.title = diseaseName;
        diseasePreventViewController.isSecondClass = YES;
        [self.navigationController pushViewController:diseasePreventViewController animated:YES];
    }
    else
    {
        NSString* diseaseName = [self.diseaseNameLevel2Array objectAtIndex:indexPath.row];
        LZDataAccess *da = [LZDataAccess singleton];
        NSArray *diseaseNames = [NSArray arrayWithObject:diseaseName];
        NSDictionary * nutrientsByDiseaseDict = [da getDiseaseNutrients_ByDiseaseNames:diseaseNames];
        NSMutableSet * nutrientSet = [NSMutableSet setWithCapacity:100];
        for ( NSString* key in nutrientsByDiseaseDict) {
            NSArray *nutrients = nutrientsByDiseaseDict[key];
            [nutrientSet addObjectsFromArray:nutrients];
        }
        NSArray *customNutrients = [LZRecommendFood getCustomNutrients:nil];
        NSArray *orderedNutrientsInSet = [LZUtility arrayIntersectSet_withArray:[NSMutableArray arrayWithArray:customNutrients] andSet:nutrientSet];
        LZDiseaseResultViewController *diseaseResultViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDiseaseResultViewController"];
        diseaseResultViewController.relatedNutritionArray = orderedNutrientsInSet;
        diseaseResultViewController.title = diseaseName;
        [self.navigationController pushViewController:diseaseResultViewController animated:YES];
    }
}

@end
