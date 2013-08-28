//
//  LZDiagnoseViewController.m
//  nutrition
//
//  Created by liu miao on 8/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDiagnoseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LZDataAccess.h"
#import "LZConstants.h"
#import "LZUtility.h"
#import "LZDiagnosisCell.h"
#import "LZRecommendFood.h"
#import "LZNutrientionManager.h"
#import "LZUserDietListViewController.h"
#import "LZDietListMakeViewController.h"
#import "LZMainPageViewController.h"
#define MaxPageNumber 4

@interface LZDiagnoseViewController ()

@end

@implementation LZDiagnoseViewController
@synthesize list1DataSourceArray,list2DataSourceArray,list3DataSourceArray,list1CheckStateArray,list2CheckStateArray,list3CheckStateArray,orderedNutrientsInSet,displayAreaHeight,maxNutrientCount;
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
    self.title = @"营养诊断";
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
    UIBarButtonItem *recheckItem = [[UIBarButtonItem alloc]initWithTitle:@"重新测试" style:UIBarButtonItemStyleBordered target:self action:@selector(recheckButtonTapped)];
    self.navigationItem.rightBarButtonItem = recheckItem;
    list1CheckStateArray = [[NSMutableArray alloc]init];
    list2CheckStateArray = [[NSMutableArray alloc]init];
    list3CheckStateArray = [[NSMutableArray alloc]init];
    
    [self.listView1.layer setCornerRadius:5];
    [self.listView1.layer setMasksToBounds:YES];
    [self.listView2.layer setCornerRadius:5];
    [self.listView2.layer setMasksToBounds:YES];
    [self.listView3.layer setCornerRadius:5];
    [self.listView3.layer setMasksToBounds:YES];
    NSArray *customNutrients = [LZRecommendFood getCustomNutrients:nil];
    maxNutrientCount = [customNutrients count];
    self.smPageControl.numberOfPages = MaxPageNumber;
    self.smPageControl.currentPage = 0;
    [self.smPageControl setPageIndicatorImage:[UIImage imageNamed:@"pageDot.png"]];
    [self.smPageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"currentPageDot.png"]];
    self.previousButton.hidden = YES;
    self.nextButton.hidden = NO;
    NSString *list_bg_path = [[NSBundle mainBundle] pathForResource:@"table_list_bg@2x" ofType:@"png"];
    UIImage * list_bg_image = [UIImage imageWithContentsOfFile:list_bg_path];
    UIImage *list_bg = [list_bg_image resizableImageWithCapInsets:UIEdgeInsetsMake(20,10,20,10)];
    [self.list1BG setImage:list_bg];
    [self.list2BG setImage:list_bg];
    [self.list3BG setImage:list_bg];
    [self.list4BG setImage:list_bg];
    UIImage *button_back_img = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.recommendFoodButton setBackgroundImage:button_back_img forState:UIControlStateNormal];
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *diseaseGroupInfoArray = [da getDiseaseGroupInfo_byType:DiseaseGroupType_wizard];
    NSArray *groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
    self.question1Label.text = @"1.您属于以下哪几种人群？(可跳过)";
    self.question2Label.text = @"2.您最近有以下哪些症状？(可跳过)";
    self.question3Label.text = @"3.您还对以下哪些保健项目感兴趣？(可跳过)";
    self.list1DataSourceArray = [da getDiseaseNamesOfGroup:groupAry[0]];
    self.list2DataSourceArray = [da getDiseaseNamesOfGroup:groupAry[1]];
    self.list3DataSourceArray = [da getDiseaseNamesOfGroup:groupAry[2]];
    [self setAllCheckState];
    [self clearResultView];
	// Do any additional setup after loading the view.
}
- (void)setAllCheckState
{
    [self.list1CheckStateArray removeAllObjects];
    [self.list2CheckStateArray removeAllObjects];
    [self.list3CheckStateArray removeAllObjects];
    for (int i =0 ; i< [self.list1DataSourceArray count]; i++)
    {
        [self.list1CheckStateArray addObject:[NSNumber numberWithBool:NO]];
    }
    for (int i =0 ; i< [self.list2DataSourceArray count]; i++)
    {
        [self.list2CheckStateArray addObject:[NSNumber numberWithBool:NO]];
    }
    for (int i =0 ; i< [self.list3DataSourceArray count]; i++)
    {
        [self.list3CheckStateArray addObject:[NSNumber numberWithBool:NO]];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.outScrollView setContentSize:CGSizeMake(self.outScrollView.frame.size.width*4, self.outScrollView.frame.size.height)];
    self.emptyImageView.center = CGPointMake(self.resultView.center.x, self.resultView.center.y-25);
    self.emptyLabel.center = CGPointMake(self.resultView.center.x, self.resultView.center.y+25);
    displayAreaHeight = self.resultView.frame.size.height-139;
}
- (void)viewDidAppear:(BOOL)animated
{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)recheckButtonTapped
{
    [self setAllCheckState];
    [self clearResultView];
    self.previousButton.hidden = YES;
    self.nextButton.hidden = NO;
    self.smPageControl.currentPage = 0;
    CGRect bounds = self.outScrollView.bounds;
    bounds.origin.x = 0;
    bounds.origin.y = 0;
    [self.outScrollView scrollRectToVisible:bounds animated:YES];
    [self.listView1 reloadData];
    [self.listView2 reloadData];
    [self.listView3 reloadData];
    [self.listView1 setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.listView2 setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.listView3 setContentOffset:CGPointMake(0, 0) animated:NO];
    
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
    self.emptyImageView.hidden = NO;
    self.resultView.hidden = YES;
    self.emptyLabel.hidden = YES;
    orderedNutrientsInSet = nil;
}
-(void)displayResult
{
    [self clearResultView];
    
    NSMutableArray *userSelectedDiseaseNames = [[NSMutableArray alloc]init];
    for (int i=0;i< [self.list1CheckStateArray count];i++)
    {
        NSNumber *checkState = [self.list1CheckStateArray objectAtIndex:i];
        if ([checkState boolValue])
        {
            NSString *diseaseName = [self.list1DataSourceArray objectAtIndex:i];
            [userSelectedDiseaseNames addObject:diseaseName];
        }
    }
    for (int i=0;i< [self.list2CheckStateArray count];i++)
    {
        NSNumber *checkState = [self.list2CheckStateArray objectAtIndex:i];
        if ([checkState boolValue])
        {
            NSString *diseaseName = [self.list2DataSourceArray objectAtIndex:i];
            [userSelectedDiseaseNames addObject:diseaseName];
        }
    }

    for (int i=0;i< [self.list3CheckStateArray count];i++)
    {
        NSNumber *checkState = [self.list3CheckStateArray objectAtIndex:i];
        if ([checkState boolValue])
        {
            NSString *diseaseName = [self.list3DataSourceArray objectAtIndex:i];
            [userSelectedDiseaseNames addObject:diseaseName];
        }
    }
    if([userSelectedDiseaseNames count] == 0)
    {
        self.emptyLabel.hidden = NO;
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
    self.orderedNutrientsInSet = [LZUtility arrayIntersectSet_withArray:[NSMutableArray arrayWithArray:customNutrients] andSet:nutrientSet];
    int totalFloor = [orderedNutrientsInSet count]/4+ (([orderedNutrientsInSet count]%4 == 0)?0:1);
    float resultLabelDisplayMaxArea = displayAreaHeight-totalFloor*40-28;
    CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap];
    
    float labelHeight = (labelSize.height > resultLabelDisplayMaxArea ? resultLabelDisplayMaxArea:labelSize.height);
    self.resultLabel.frame = CGRectMake(10, 38, 280, labelHeight);
    self.resultLabel.text = text;
    CGRect nutrientFrame = self.nutrientTipLabel.frame;
    nutrientFrame.origin.y   = 38+labelHeight+10;
    self.nutrientTipLabel.frame = nutrientFrame;
    
    float startY = 38+labelHeight+10+18+10;
    int floor = 1;
    int countPerRow = 4;
    float startX;
    for (int i = 0; i< [orderedNutrientsInSet count];i++)
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
        NSString *key = [orderedNutrientsInSet objectAtIndex:i];
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
    self.emptyImageView.hidden = YES;
    self.resultView.hidden = NO;
    

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
    NSSet *selectNutrient = [NSSet setWithArray:self.orderedNutrientsInSet];
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
-(void)nutrientButtonTapped:(UIButton *)nutrientButton
{
    int tag = nutrientButton.tag-101;
    NSString *key = [orderedNutrientsInSet objectAtIndex:tag];
    [[LZNutrientionManager SharedInstance]showNutrientInfo:key];
}
-(void)cancelButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setOutScrollView:nil];
    [self setListView1:nil];
    [self setListView2:nil];
    [self setListView3:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setSmPageControl:nil];
    [self setList1BG:nil];
    [self setList2BG:nil];
    [self setList3BG:nil];
    [self setList4BG:nil];
    [self setResultLabel:nil];
    [self setResultView:nil];
    [self setRecommendFoodButton:nil];
    [self setQuestion1Label:nil];
    [self setQuestion2Label:nil];
    [self setQuestion3Label:nil];
    [self setEmptyImageView:nil];
    [self setEmptyLabel:nil];
    [self setNutrientTipLabel:nil];
    [super viewDidUnload];
}
/*    
 if (tableView == self.listView1)
 {
 }
 else if (tableView == self.listView2)
 {
 
 }
 else
 {
 
 }
 */
#pragma mark- TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.listView1)
    {
        return [self.list1DataSourceArray count];
    }
    else if (tableView == self.listView2)
    {
        return [self.list2DataSourceArray count];
    }
    else
    {
        return [self.list3DataSourceArray count];
    }
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    return sectionView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 280, 40)];
//    [titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
//    [titleLabel setTextColor:[UIColor blackColor]];
//    [titleLabel setBackgroundColor:[UIColor colorWithRed:244/255.f green:242/255.f blue:236/255.f alpha:1.0f]];
//    if (tableView == self.listView1)
//    {
//        titleLabel.text = @"您属于以下哪几种人群?";
//    }
//    else if (tableView == self.listView2)
//    {
//        titleLabel.text = @"您属于以下哪几种人群?";
//    }
//    else
//    {
//       titleLabel.text = @"您属于以下哪几种人群?"; 
//    }
//    [sectionView addSubview:titleLabel];
//    return sectionView;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZDiagnosisCell * cell =(LZDiagnosisCell*)[tableView dequeueReusableCellWithIdentifier:@"LZDiagnosisCell"];
    NSString *diseaseName = @"";
    BOOL isStateOn = NO;
    if (tableView == self.listView1)
    {
        cell.sepratorLineView.hidden = (indexPath.row == [self.list1DataSourceArray count]-1);
        diseaseName = [self.list1DataSourceArray objectAtIndex:indexPath.row];
        NSNumber *checkState = [self.list1CheckStateArray objectAtIndex:indexPath.row];
        isStateOn = [checkState boolValue];
    }
    else if (tableView == self.listView2)
    {
        cell.sepratorLineView.hidden = (indexPath.row == [self.list2DataSourceArray count]-1);
        diseaseName = [self.list2DataSourceArray objectAtIndex:indexPath.row];
        NSNumber *checkState = [self.list2CheckStateArray objectAtIndex:indexPath.row];
        isStateOn = [checkState boolValue];
    }
    else
    {
        cell.sepratorLineView.hidden = (indexPath.row == [self.list3DataSourceArray count]-1);
        diseaseName = [self.list3DataSourceArray objectAtIndex:indexPath.row];
        NSNumber *checkState = [self.list3CheckStateArray objectAtIndex:indexPath.row];
        isStateOn = [checkState boolValue];
    }
    cell.diseaseNameLabel.text = diseaseName;
    cell.checkImageView.hidden = !isStateOn;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.listView1)
    {
        NSNumber *checkState = [self.list1CheckStateArray objectAtIndex:indexPath.row];
        NSNumber *oppositeState = [NSNumber numberWithBool:![checkState boolValue]];
        [self.list1CheckStateArray replaceObjectAtIndex:indexPath.row withObject:oppositeState];
        
    }
    else if (tableView == self.listView2)
    {
        NSNumber *checkState = [self.list2CheckStateArray objectAtIndex:indexPath.row];
        NSNumber *oppositeState = [NSNumber numberWithBool:![checkState boolValue]];
        [self.list2CheckStateArray replaceObjectAtIndex:indexPath.row withObject:oppositeState];
    }
    else
    {
        NSNumber *checkState = [self.list3CheckStateArray objectAtIndex:indexPath.row];
        NSNumber *oppositeState = [NSNumber numberWithBool:![checkState boolValue]];
        [self.list3CheckStateArray replaceObjectAtIndex:indexPath.row withObject:oppositeState];
    }
    NSArray *reloadIndex = [NSArray arrayWithObject:indexPath];
    [tableView reloadRowsAtIndexPaths:reloadIndex withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    if (scrollView == self.outScrollView)
    {
        CGFloat pageWidth = CGRectGetWidth(self.outScrollView.frame);
        NSUInteger prePage = self.smPageControl.currentPage;

        NSUInteger page = floor((self.outScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if (prePage == page)
        {
            return;
        }
        if (prePage == MaxPageNumber-1)
        {
            [self clearResultView];
        }
        self.smPageControl.currentPage = page;
        if (page == 0)
        {
            self.previousButton.hidden = YES;
            self.nextButton.hidden = NO;
        }
        else if(page == MaxPageNumber-1)
        {
            self.previousButton.hidden = NO;
            self.nextButton.hidden = YES;
            [self displayResult];
        }
        else
        {
            self.previousButton.hidden = NO;
            self.nextButton.hidden = NO;
        }
        
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    }
    
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}
- (IBAction)changePage:(UIButton *)sender
{
    NSInteger page = self.smPageControl.currentPage;
    if(sender == self.previousButton)
    {
        if (page == 0)
        {
            return;
        }
        if (page == MaxPageNumber-1) {
            [self clearResultView];
        }
        page -=1;
        self.smPageControl.currentPage = page;
        CGRect bounds = self.outScrollView.bounds;
        bounds.origin.x = CGRectGetWidth(bounds) * page;
        bounds.origin.y = 0;
        [self.outScrollView scrollRectToVisible:bounds animated:YES];
    }
    else
    {
        if (page == MaxPageNumber-1) {
            return;
        }
        page+=1;
        self.smPageControl.currentPage = page;
        CGRect bounds = self.outScrollView.bounds;
        bounds.origin.x = CGRectGetWidth(bounds) * page;
        bounds.origin.y = 0;
        [self.outScrollView scrollRectToVisible:bounds animated:YES];
    }
    if (page == 0)
    {
        self.previousButton.hidden = YES;
        self.nextButton.hidden = NO;
    }
    else if(page == MaxPageNumber-1)
    {
        self.previousButton.hidden = NO;
        self.nextButton.hidden = YES;
        [self displayResult];
    }
    else
    {
        self.previousButton.hidden = NO;
        self.nextButton.hidden = NO;
    }

}

@end
