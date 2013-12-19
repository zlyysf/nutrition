//
//  NGRecordHistoryViewController.m
//  nutrition
//
//  Created by liu miao on 11/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGRecordHistoryViewController.h"
#import "NGRecordCell.h"
#import "LZDataAccess.h"
#import "LZUtility.h"
#import "LZConstants.h"
@interface NGRecordHistoryViewController ()
//@property (nonatomic,strong)NGCycleScrollView* cycleView;
@property (nonatomic,strong)NSArray *distinctMonthsArray;
@property (nonatomic,assign)int currentPage;
@property (nonatomic,assign)int totalPage;
@property (nonatomic,strong)NSMutableDictionary *historyDict;
@property (nonatomic,strong)NSMutableArray *table1DataSource;
@property (nonatomic,strong)NSMutableArray *table2DataSource;
@property (nonatomic,strong)NSMutableArray *table3DataSource;
@end

@implementation NGRecordHistoryViewController
//@synthesize cycleView;
@synthesize distinctMonthsArray,currentPage,historyDict,totalPage,table1DataSource,table2DataSource,table3DataSource;
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
    historyDict = [[NSMutableDictionary alloc]init];
    table1DataSource = [[NSMutableArray alloc]init];
    table2DataSource = [[NSMutableArray alloc]init];
    table3DataSource = [[NSMutableArray alloc]init];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.listView1.tableFooterView = footerView;
    self.listView2.tableFooterView = footerView;
    self.listView3.tableFooterView = footerView;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltoprevious)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltonext)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initialize];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(historyUpdated:) name: Notification_HistoryUpdatedKey object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (IOS7_OR_LATER)
    {
        [self.listView1 setSectionIndexBackgroundColor:[UIColor clearColor]];
        [self.listView1 setSectionIndexColor:[UIColor colorWithRed:6/255.f green:62/255.f blue:4/255.f alpha:1.0f]];
        [self.listView1 setSectionIndexTrackingBackgroundColor :[UIColor whiteColor]];
        [self.listView2 setSectionIndexBackgroundColor:[UIColor clearColor]];
        [self.listView2 setSectionIndexTrackingBackgroundColor :[UIColor whiteColor]];
        [self.listView2 setSectionIndexColor:[UIColor colorWithRed:6/255.f green:62/255.f blue:4/255.f alpha:1.0f]];
        [self.listView3 setSectionIndexBackgroundColor:[UIColor clearColor]];
        [self.listView3 setSectionIndexTrackingBackgroundColor :[UIColor whiteColor]];
        [self.listView3 setSectionIndexColor:[UIColor colorWithRed:6/255.f green:62/255.f blue:4/255.f alpha:1.0f]];
        //[self.listView setSectionIndexColor:[UIColor blackColor]];
    }
}

-(void)historyUpdated:(NSNotification *)notification
{
    [self initialize];
}
-(void)initialize
{
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *array = [da getUserRecordSymptom_DistinctMonth];
    distinctMonthsArray = [[NSArray alloc]initWithArray:array];
    [self.historyDict removeAllObjects];
    if ([distinctMonthsArray count]<=1)
    {
        totalPage = 1;
        currentPage = 0;
    }
    else
    {
        NSNumber *first = [distinctMonthsArray objectAtIndex:0];
        NSNumber *last = [distinctMonthsArray lastObject];
        int firstYear =[first intValue]/100;
        int lastYear = [last intValue]/100;
        int firstMonth = [first intValue]%100;
        int lastMonth = [last intValue]%100;
        totalPage =(lastYear - firstYear)*12+lastMonth-firstMonth+1;
        currentPage = totalPage-1;
        CGFloat height = self.contentScrollView.frame.size.height;
        [self.contentScrollView setContentSize:CGSizeMake(totalPage*320, height)];
    }
    [self displayContentForPage:currentPage];
}
-(void)displayContentForPage:(int)page
{
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.contentScrollView setContentOffset:CGPointMake(currentPage*320, 0) animated:YES];
    CGFloat height =self.contentScrollView.frame.size.height;
    for (UIView *view in self.contentScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    if (totalPage == 1)
    {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        if ([distinctMonthsArray count]==0)//empty
        {
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDate *todayDate = [NSDate date];
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
            NSDateComponents* comp1 = [calendar components:unitFlags fromDate:todayDate];
            self.navigationItem.title = [NSString stringWithFormat:@"%d.%d",comp1.year,comp1.month];
        }
        else
        {
            [self.contentScrollView addSubview:self.listView1];
            [self.listView1 setFrame:CGRectMake(0, 0, 320,height )];
            NSNumber *startLocal = [distinctMonthsArray objectAtIndex:0];
            self.navigationItem.title = [NSString stringWithFormat:@"%d.%d",[startLocal intValue]/100,[startLocal intValue]%100];
            [self.table1DataSource removeAllObjects];
            [self.table1DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:[startLocal intValue]]];
            [self.listView1 reloadData];
        }
    }
    else
    {
        NSNumber *startLocal =[distinctMonthsArray objectAtIndex:0];
        int currentLocal = [LZUtility getMonthLocalForDistance:currentPage startLocal:[startLocal intValue]];
        int preLoacal =[LZUtility getMonthLocalForDistance:currentPage-1 startLocal:[startLocal intValue]];
        int nextLocal = [LZUtility getMonthLocalForDistance:currentPage+1 startLocal:[startLocal intValue]];
        self.navigationItem.title = [NSString stringWithFormat:@"%d.%d",currentLocal/100,currentLocal%100];
        if (currentPage == 0)
        {
            [self.navigationItem.leftBarButtonItem setEnabled:NO];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];

            [self.contentScrollView addSubview:self.listView1];
            //update dataSource
            [self.listView1 setFrame:CGRectMake(currentPage*320, 0, 320, height)];
            [self.table1DataSource removeAllObjects];
            [self.table1DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:currentLocal]];
            [self.listView1 reloadData];
            
            [self.contentScrollView addSubview:self.listView2];
            [self.listView2 setFrame:CGRectMake((currentPage+1)*320, 0, 320,height)];
            [self.table2DataSource removeAllObjects];
            [self.table2DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:nextLocal]];
            [self.listView2 reloadData];
        }
        else if (currentPage == totalPage-1)
        {
            int index = currentPage%3;
            CGRect currentRect = CGRectMake(currentPage*320, 0, 320, height);
            CGRect preRect = CGRectMake((currentPage-1)*320, 0, 320, height);
            if (index == 0)
            {
                [self.contentScrollView addSubview:self.listView1];
                [self.listView1 setFrame:currentRect];
                [self.table1DataSource removeAllObjects];
                [self.table1DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:currentLocal]];
                [self.listView1 reloadData];
                [self.contentScrollView addSubview:self.listView3];
                [self.listView3 setFrame:preRect];
                [self.table3DataSource removeAllObjects];
                [self.table3DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:preLoacal]];
                [self.listView3 reloadData];
            }
            else if (index == 1)
            {
                [self.contentScrollView addSubview:self.listView2];
                [self.listView2 setFrame:currentRect];
                [self.table2DataSource removeAllObjects];
                [self.table2DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:currentLocal]];
                [self.listView2 reloadData];
                [self.contentScrollView addSubview:self.listView1];
                [self.listView1 setFrame:preRect];
                [self.table1DataSource removeAllObjects];
                [self.table1DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:preLoacal]];
                [self.listView1 reloadData];
            }
            else
            {
                [self.contentScrollView addSubview:self.listView3];
                [self.listView3 setFrame:currentRect];
                [self.table3DataSource removeAllObjects];
                [self.table3DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:currentLocal]];
                [self.listView3 reloadData];
                [self.contentScrollView addSubview:self.listView2];
                [self.listView2 setFrame:preRect];
                [self.table2DataSource removeAllObjects];
                [self.table2DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:preLoacal]];
                [self.listView2 reloadData];
            }
            [self.navigationItem.leftBarButtonItem setEnabled:YES];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }
        else
        {
            int index = currentPage%3;
            CGRect currentRect = CGRectMake(currentPage*320, 0, 320, height);
            CGRect preRect = CGRectMake((currentPage-1)*320, 0, 320, height);
            CGRect nextRect =CGRectMake((currentPage+1)*320, 0, 320, height);
            [self.contentScrollView addSubview:self.listView1];
            [self.contentScrollView addSubview:self.listView2];
            [self.contentScrollView addSubview:self.listView3];
            if (index == 0)
            {
                [self.listView1 setFrame:currentRect];
                [self.listView2 setFrame:nextRect];
                [self.listView3 setFrame:preRect];
                [self.table1DataSource removeAllObjects];
                [self.table1DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:currentLocal]];
                [self.listView1 reloadData];

                [self.table2DataSource removeAllObjects];
                [self.table2DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:nextLocal]];
                [self.listView2 reloadData];

                [self.table3DataSource removeAllObjects];
                [self.table3DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:preLoacal]];
                [self.listView3 reloadData];

            }
            else if (index == 1)
            { 
                [self.listView1 setFrame:preRect];
                [self.listView2 setFrame:currentRect];
                [self.listView3 setFrame:nextRect];
                [self.table1DataSource removeAllObjects];
                [self.table1DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:preLoacal]];
                [self.listView1 reloadData];
                
                [self.table2DataSource removeAllObjects];
                [self.table2DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:currentLocal]];
                [self.listView2 reloadData];
                
                [self.table3DataSource removeAllObjects];
                [self.table3DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:nextLocal]];
                [self.listView3 reloadData];
            }
            else
            {
                [self.listView1 setFrame:nextRect];
                [self.listView2 setFrame:preRect];
                [self.listView3 setFrame:currentRect];
                [self.table1DataSource removeAllObjects];
                [self.table1DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:nextLocal]];
                [self.listView1 reloadData];
                
                [self.table2DataSource removeAllObjects];
                [self.table2DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:preLoacal]];
                [self.listView2 reloadData];
                
                [self.table3DataSource removeAllObjects];
                [self.table3DataSource addObjectsFromArray:[self getDataSourceForMonthLocal:currentLocal]];
                [self.listView3 reloadData];
            }
            [self.navigationItem.leftBarButtonItem setEnabled:YES];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }
    }
}
-(NSArray *)getDataSourceForMonthLocal:(int)monthLocal
{

    NSString *key = [NSString stringWithFormat:@"%d",monthLocal];
    NSArray *data = [self.historyDict objectForKey:key];
    if (data != nil && [data count]!= 0)
    {
        return data;
    }
    else
    {
        LZDataAccess *da = [LZDataAccess singleton];
        int thisStartLocal = monthLocal*100+1;
        int thisEndLocal = monthLocal*100+32;
        NSArray *thisData = [da getUserRecordSymptomDataByRange_withStartDayLocal:thisStartLocal andEndDayLocal:thisEndLocal andStartMonthLocal:0 andEndMonthLocal:0];
        if (thisData != nil && [thisData count]!= 0)
        {
            [self.historyDict setObject:thisData forKey:key];
            return thisData;
        }
        else
        {
            return nil;
        }
    }
}
-(void)scrolltoprevious
{
    currentPage = currentPage-1;
    [self displayContentForPage:currentPage];
//    NSLog(@"%@",self.cycleView.scrollView.subviews);
//    [self.cycleView scrollToPreviousPage];
}
-(void)scrolltonext
{
    currentPage = currentPage+1;
    [self displayContentForPage:currentPage];
//    NSLog(@"%@",self.cycleView.scrollView.subviews);
//    [self.cycleView scrollToNextPage];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.listView1)
    {
        NGRecordCell *cell = (NGRecordCell*)[self.listView1 dequeueReusableCellWithIdentifier:@"NGRecordCell"];
        [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.backView.layer setBorderWidth:0.5f];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        label.numberOfLines = 0;
        [cell.backView addSubview:label];
        
        NSDictionary *record = [self.table1DataSource objectAtIndex:indexPath.section];
        label.text  =[[record allKeys]description];
        return cell;
    }
    else if(tableView == self.listView2)
    {
        NGRecordCell *cell = (NGRecordCell*)[self.listView2 dequeueReusableCellWithIdentifier:@"NGRecordCell"];
        [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.backView.layer setBorderWidth:0.5f];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        label.numberOfLines = 0;
        [cell.backView addSubview:label];
        
        NSDictionary *record = [self.table2DataSource objectAtIndex:indexPath.section];
        label.text  =[[record allKeys]description];
        return cell;
    }
    else
    {
        NGRecordCell *cell = (NGRecordCell*)[self.listView3 dequeueReusableCellWithIdentifier:@"NGRecordCell"];
        [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.backView.layer setBorderWidth:0.5f];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        label.numberOfLines = 0;
        [cell.backView addSubview:label];
        
        NSDictionary *record = [self.table3DataSource objectAtIndex:indexPath.section];
        label.text  =[[record allKeys]description];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    if (tableView == self.listView1)
    {
        return [table1DataSource count];
        
    }
    else if (tableView == self.listView2)
    {
        return [table2DataSource count];
    }
    else
    {
        return [table3DataSource count];
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
//
//// Editing


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
// return list of section titles to display in section index view (e.g. "ABCD...Z#")
{
    NSMutableArray *titleArray = [[NSMutableArray alloc]init];
    if (tableView == self.listView1)
    {
        for ( NSDictionary *dict in self.table1DataSource)
        {
            NSNumber *dayLocal = [dict objectForKey:@"DayLocal"];
            int x = [dayLocal intValue]%100;
            NSString *title = [NSString stringWithFormat:@"%d",x];
            [titleArray addObject:title];
        }

    }
    else if (tableView == self.listView2)
    {
        for ( NSDictionary *dict in self.table2DataSource)
        {
            NSNumber *dayLocal = [dict objectForKey:@"DayLocal"];
            int x = [dayLocal intValue]%100;
            NSString *title = [NSString stringWithFormat:@"%d",x];
            [titleArray addObject:title];
        }
    }
    else
    {
        for ( NSDictionary *dict in self.table3DataSource)
        {
            NSNumber *dayLocal = [dict objectForKey:@"DayLocal"];
            int x = [dayLocal intValue]%100;
            NSString *title = [NSString stringWithFormat:@"%d",x];
            [titleArray addObject:title];
        }
    }
    return titleArray;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index  // tell table which section corresponds to section title/index (e.g. "B",1))
{
    return index;
}
#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 465;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 120;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 20;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
//    UIView * sub = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 100)];
//    [sub setBackgroundColor:[UIColor whiteColor]];
//    [view addSubview:sub];
//    [view setBackgroundColor:[UIColor lightGrayColor]];
//    return view;
//}
// custom view for header. will be adjusted to default or specified header height
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//}// custom view for footer. will be adjusted to default or specified footer height
//-(void)didChangeToPage:(NSInteger)index
//{
//    NSLog(@"did change to %d",index);
//}
//- (UIView *)pageAtIndex:(NSInteger)index
//{
//    UIView *newView = [[UIView alloc]initWithFrame:cycleView.bounds];
//    [newView setBackgroundColor:[UIColor clearColor]];
//    int newIndex;
//    if (index <0)
//    {
//        int i;
//        for (i=1; i*3+index<0; i++)
//        {
//        }
//        newIndex = i*3+index;
//        
//    }
//    else
//    {
//        newIndex = index;
//    }
//    NSLog(@"require %d",index);
//    if (newIndex%3 == 0)
//    {
//        
//        [newView addSubview:self.listView1];
//        [self.listView1 reloadData];
//        
//    }
//    else if(newIndex%3 == 1)
//    {
//        [newView addSubview:self.listView2];
//        [self.listView2 reloadData];
//
//    }
//    else
//    {
//        [newView addSubview:self.listView3];
//        [self.listView3 reloadData];
//
//    }
//    return  newView;
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGSize pageSize = scrollView.frame.size;
    currentPage = floor(scrollView.contentOffset.x / pageSize.width);
    if (currentPage < 0 || currentPage >= totalPage)
    {
        return;
    }
    [self displayContentForPage:currentPage];
    //[self.photoScrollView setContentOffset:CGPointMake(self.view.bounds.size.width  * currentPhotoIndex, 0)];
}

@end
