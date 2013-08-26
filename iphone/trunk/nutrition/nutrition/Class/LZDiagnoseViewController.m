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
#define MaxPageNumber 4

@interface LZDiagnoseViewController ()

@end

@implementation LZDiagnoseViewController
@synthesize list1DataSourceArray,list2DataSourceArray,list3DataSourceArray,list1CheckStateArray,list2CheckStateArray,list3CheckStateArray;
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
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *diseaseGroupInfoArray = [da getDiseaseGroupInfo_byType:DiseaseGroupType_wizard];
    NSArray *groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
    self.list1DataSourceArray = [da getDiseaseNamesOfGroup:groupAry[0]];
    self.list2DataSourceArray = [da getDiseaseNamesOfGroup:groupAry[1]];
    self.list3DataSourceArray = [da getDiseaseNamesOfGroup:groupAry[2]];
    [self setAllCheckState];
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
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 280, 40)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setBackgroundColor:[UIColor colorWithRed:244/255.f green:242/255.f blue:236/255.f alpha:1.0f]];
    if (tableView == self.listView1)
    {
        titleLabel.text = @"您属于以下哪几种人群?";
    }
    else if (tableView == self.listView2)
    {
        titleLabel.text = @"您属于以下哪几种人群?";
    }
    else
    {
       titleLabel.text = @"您属于以下哪几种人群?"; 
    }
    [sectionView addSubview:titleLabel];
    return sectionView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZDiagnosisCell * cell =(LZDiagnosisCell*)[tableView dequeueReusableCellWithIdentifier:@"LZDiagnosisCell"];
    NSString *diseaseName = @"";
    BOOL isStateOn = NO;
    if (tableView == self.listView1)
    {
        diseaseName = [self.list1DataSourceArray objectAtIndex:indexPath.row];
        NSNumber *checkState = [self.list1CheckStateArray objectAtIndex:indexPath.row];
        isStateOn = [checkState boolValue];
    }
    else if (tableView == self.listView2)
    {
        diseaseName = [self.list2DataSourceArray objectAtIndex:indexPath.row];
        NSNumber *checkState = [self.list2CheckStateArray objectAtIndex:indexPath.row];
        isStateOn = [checkState boolValue];
    }
    else
    {
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
        NSUInteger page = floor((self.outScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
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
    }
    else
    {
        self.previousButton.hidden = NO;
        self.nextButton.hidden = NO;
    }

}

@end
