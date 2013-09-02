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
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc]initWithTitle:@"诊断" style:UIBarButtonItemStyleBordered target:self action:@selector(checkItemTapped)];
    self.navigationItem.rightBarButtonItem = checkItem;
}
-(void)checkItemTapped
{
    
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
    return 44;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 15;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    return sectionView;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 32)];
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
