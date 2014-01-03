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
#import "LZNutrientionManager.h"
#import "NGHealthReportViewController.h"
#define MAXNutritonDisplayCount 3
@interface NGRecordHistoryViewController ()
{
    BOOL isChinese;
}
//@property (nonatomic,strong)NGCycleScrollView* cycleView;
@property (nonatomic,strong)NSArray *distinctMonthsArray;
@property (nonatomic,assign)int currentPage;
@property (nonatomic,assign)int totalPage;
@property (nonatomic,strong)NSMutableDictionary *historyDict;
@property (nonatomic,strong)NSMutableArray *table1DataSource;
@property (nonatomic,strong)NSMutableArray *table2DataSource;
@property (nonatomic,strong)NSMutableArray *table3DataSource;
@property (nonatomic,strong)NSDictionary *symptomRowsDict;
@property (nonatomic,strong)NSArray *symptomTypeRows;
@property (nonatomic,strong) UILabel *recordEmptyDisplayLabel;
@end

@implementation NGRecordHistoryViewController
//@synthesize cycleView;
@synthesize distinctMonthsArray,currentPage,historyDict,totalPage,table1DataSource,table2DataSource,table3DataSource,symptomRowsDict,symptomTypeRows,recordEmptyDisplayLabel;
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
    [leftItem setEnabled:NO];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltonext)];
    [rightItem setEnabled:NO];
    self.navigationItem.rightBarButtonItem = rightItem;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(historyUpdated:) name: Notification_HistoryUpdatedKey object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LZDataAccess *da = [LZDataAccess singleton];

        symptomTypeRows = [da getSymptomTypeRows_withForSex:ForSex_both];
        
        NSArray* symptomTypeIdArray = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_SymptomTypeId andDictionaryArray:symptomTypeRows];
        symptomRowsDict = [da getSymptomRowsByTypeDict_BySymptomTypeIds:symptomTypeIdArray];
        isChinese = [LZUtility isCurrentLanguageChinese];
        dispatch_async(dispatch_get_main_queue(), ^{
                [self initialize];
        });
    });
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
    if (self.recordEmptyDisplayLabel != nil && self.recordEmptyDisplayLabel.superview)
    {
        [self.recordEmptyDisplayLabel removeFromSuperview];
    }
    if (totalPage == 1)
    {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        if ([distinctMonthsArray count]==0)//empty
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDate *todayDate = [NSDate date];
                unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
                NSDateComponents* comp1 = [calendar components:unitFlags fromDate:todayDate];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.navigationItem.title = [NSString stringWithFormat:@"%d.%d",comp1.year,comp1.month];
                    if (self.recordEmptyDisplayLabel == nil)
                    {
                        self.recordEmptyDisplayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 300, 30)];
                        [self.recordEmptyDisplayLabel setText:NSLocalizedString(@"lishi_c_wulishi", @"历史页为空提示：无历史记录!")];
                        [self.recordEmptyDisplayLabel setTextColor:[UIColor colorWithRed:125/255.f green:125/255.f blue:125/255.f alpha:1.0f]];
                        [self.recordEmptyDisplayLabel setFont:[UIFont systemFontOfSize:17]];
                        [self.recordEmptyDisplayLabel setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
                        [self.recordEmptyDisplayLabel setTextAlignment:UITextAlignmentCenter];
                        [self.view addSubview:self.recordEmptyDisplayLabel];
                        self.recordEmptyDisplayLabel.center = self.view.center;
                    }
                    else
                    {
                        [self.view addSubview:self.recordEmptyDisplayLabel];
                        self.recordEmptyDisplayLabel.center = self.view.center;
                    }
                });
            });
            
            
            
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *record;
    if (tableView == self.listView1)
    {
        record = [self.table1DataSource objectAtIndex:indexPath.section];
    }
    else if(tableView == self.listView2)
    {
        record = [self.table2DataSource objectAtIndex:indexPath.section];
        
    }
    else
    {
        record = [self.table3DataSource objectAtIndex:indexPath.section];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGHealthReportViewController *healthReportViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGHealthReportViewController"];

    NSDictionary *InputNameValuePairsData = [record objectForKey:@"inputNameValuePairs"];
    NSMutableDictionary *userInputValueDict = [[NSMutableDictionary alloc]init];
    NSNumber *temperature = [InputNameValuePairsData objectForKey:Key_BodyTemperature];
    if (temperature != nil)
    {
        NSString *temperatureStr = [NSString stringWithFormat:@"%f",[temperature doubleValue]];
        [userInputValueDict setObject:temperatureStr forKey:@"heat"];
    }
    NSNumber *weight = [InputNameValuePairsData objectForKey:Key_Weight];
    if (weight != nil)
    {
        NSString *weightStr = [NSString stringWithFormat:@"%f",[weight doubleValue]];
        [userInputValueDict setObject:weightStr forKey:@"weight"];
    }

    NSNumber *heartRate = [InputNameValuePairsData objectForKey:Key_HeartRate];
    if (heartRate != nil)
    {
        NSString *heartRateStr = [NSString stringWithFormat:@"%d",[heartRate intValue]];
        [userInputValueDict setObject:heartRateStr forKey:@"heartbeat"];
    }

    NSNumber *pressureLow = [InputNameValuePairsData objectForKey:Key_BloodPressureLow];
    if (pressureLow != nil)
    {
        NSString *pressureLowStr = [NSString stringWithFormat:@"%d",[pressureLow intValue]];
        [userInputValueDict setObject:pressureLowStr forKey:@"lowpressure"];
    }

    NSNumber *pressureHigh = [InputNameValuePairsData objectForKey:Key_BloodPressureHigh];
    if (pressureHigh != nil)
    {
        NSString *pressureHighStr = [NSString stringWithFormat:@"%d",[pressureHigh intValue]];
        [userInputValueDict setObject:pressureHighStr forKey:@"highpressure"];
    }

//    if ([measureData objectForKey:Key_BodyTemperature]) {
//        [InputNameValuePairsData setObject:[measureData objectForKey:Key_BodyTemperature] forKey:Key_BodyTemperature];
//    }
//    if ([measureData objectForKey:Key_Weight]) {
//        [InputNameValuePairsData setObject:[measureData objectForKey:Key_Weight] forKey:Key_Weight];
//    }
//    if ([measureData objectForKey:Key_HeartRate]) {
//        [InputNameValuePairsData setObject:[measureData objectForKey:Key_HeartRate] forKey:Key_HeartRate];
//    }
//    if ([measureData objectForKey:Key_BloodPressureLow]) {
//        [InputNameValuePairsData setObject:[measureData objectForKey:Key_BloodPressureLow] forKey:Key_BloodPressureLow];
//    }
//    if ([measureData objectForKey:Key_BloodPressureHigh]) {
//        [InputNameValuePairsData setObject:[measureData objectForKey:Key_BloodPressureHigh] forKey:Key_BloodPressureHigh];
//    }

    healthReportViewController.userInputValueDict = userInputValueDict;
    healthReportViewController.userSelectedSymptom = [InputNameValuePairsData objectForKey:Key_Symptoms];
    healthReportViewController.symptomsByTypeArray = [InputNameValuePairsData objectForKey:Key_SymptomsByType];
    healthReportViewController.isOnlyDisplay = YES;
    [self.navigationController pushViewController:healthReportViewController animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NGRecordCell *cell;
    NSDictionary *record;
    if (tableView == self.listView1)
    {
        cell = (NGRecordCell*)[self.listView1 dequeueReusableCellWithIdentifier:@"NGRecordCell"];
        record = [self.table1DataSource objectAtIndex:indexPath.section];
    }
    else if(tableView == self.listView2)
    {
        cell = (NGRecordCell*)[self.listView2 dequeueReusableCellWithIdentifier:@"NGRecordCell"];
        record = [self.table2DataSource objectAtIndex:indexPath.section];

    }
    else
    {
        cell = (NGRecordCell*)[self.listView3 dequeueReusableCellWithIdentifier:@"NGRecordCell"];
        record = [self.table3DataSource objectAtIndex:indexPath.section];
    }
    
    [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.backView.layer setBorderWidth:0.5f];
    for (UIView *sbview in cell.backView.subviews)
    {
        [sbview removeFromSuperview];
    }
    [cell.backView setClipsToBounds:YES];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate *recordDate = [record objectForKey:@"UpdateTimeUTC"];
    unsigned unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit  | NSDayCalendarUnit |NSWeekdayCalendarUnit;
    NSDateComponents* component = [calendar components:unitFlags fromDate:recordDate];
    int week = [component weekday];
    int month = [component month];
    int day = [component day];
    //加标题栏 包括日期和星期
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 120, 24)];
    [cell.backView addSubview:dateLabel];
    [dateLabel setFont:[UIFont systemFontOfSize:20]];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"lishi_c_riqi", @"历史页日期：%d月%d日"),month,day];
    
    UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(225, 10, 65, 21)];
    weekLabel.text =[self week:week];
    weekLabel.textAlignment = UITextAlignmentRight;
    [weekLabel setFont:[UIFont systemFontOfSize:14]];
    [weekLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0f]];
    [cell.backView addSubview:weekLabel];
    
    UIImageView *sepLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 300, 1)];
    [cell.backView  addSubview:sepLine1];
    [sepLine1 setImage:[UIImage imageNamed:@"gray_horizon_line.png"]];
    [sepLine1 setContentMode:UIViewContentModeCenter];
    
    //加健康分数和营养素
    NSDictionary *calculateNameValuePairs = [record objectForKey:@"calculateNameValuePairs"];
    NSDictionary *lackNutrientsAndFoods = [calculateNameValuePairs objectForKey:Key_LackNutrientsAndFoods];
    NSNumber *healthMark = [calculateNameValuePairs objectForKey:Key_HealthMark];
    NSString *healthStr = [LZUtility getAccurateStringWithDecimal:[healthMark doubleValue]];
    NSArray *keys =[lackNutrientsAndFoods allKeys];
    int totalItemCount = ([keys count]>MAXNutritonDisplayCount ? MAXNutritonDisplayCount:[keys count])+1;
    int floor = 1;
    float startX;
    int perRowCount = 5;
    float startY = 40;
    int delta = 0;
    for (int i=0; i< totalItemCount; i++)
    {
        
        if (i>=floor *perRowCount)
        {
            startY += 40;
            floor+=1;
        }
        if (i>0)
        {
            delta = -20;
        }
        startX = 10+(i-(floor-1)*perRowCount)*70+delta;
        
        if(i == 0)
        {
            UILabel *healthLabel = [[UILabel alloc]initWithFrame:CGRectMake(startX, startY,40, 30)];
            [healthLabel setFont:[UIFont systemFontOfSize:14]];
            healthLabel.textAlignment = UITextAlignmentCenter;
            healthLabel.text = healthStr;
            [healthLabel.layer setMasksToBounds:YES];
            [healthLabel.layer setCornerRadius:5];
            [healthLabel.layer setBorderWidth:0.5f];
            [healthLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            //255,228,38
            [healthLabel setBackgroundColor:[UIColor colorWithRed:255/255.f green:208/255.f blue:204/255.f alpha:1.0f]];
            [cell.backView addSubview:healthLabel];
        }
        else
        {
            NSString *nutritionId =[keys objectAtIndex:i-1];
            UIColor *backColor =[LZUtility getNutrientColorForNutrientId:nutritionId];
            UILabel *nutritionLabel = [[UILabel alloc]initWithFrame:CGRectMake(startX, startY,60, 30)];
            [nutritionLabel setFont:[UIFont systemFontOfSize:14]];
            nutritionLabel.textAlignment = UITextAlignmentCenter;
            nutritionLabel.text = [self getNutritionName:nutritionId];
            [nutritionLabel.layer setMasksToBounds:YES];
            [nutritionLabel.layer setCornerRadius:5];
            [nutritionLabel.layer setBorderWidth:0.5f];
            [nutritionLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            //255,228,38
            [nutritionLabel setBackgroundColor:backColor];
            [cell.backView addSubview:nutritionLabel];
        }
        
    }
    startY += 40;
    //加用户选择的症状
    NSDictionary *inputNameValuePairs = [record objectForKey:@"inputNameValuePairs"];
    NSArray *symptomTypeArray = [inputNameValuePairs objectForKey:Key_SymptomsByType];
    if (symptomTypeArray != nil && [symptomTypeArray count]!= 0)//有选择的症状
    {
        UIImageView *sepLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, startY, 300, 1)];
        [cell.backView  addSubview:sepLine2];
        [sepLine2 setImage:[UIImage imageNamed:@"gray_horizon_line.png"]];
        [sepLine2 setContentMode:UIViewContentModeCenter];
        startY += 5;
        UILabel *headerLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, startY, 160, 20)];
        [headerLabel setFont:[UIFont systemFontOfSize:14]];
        [headerLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:10.f]];
        [headerLabel setText:NSLocalizedString(@"lishi_c_zhengzhuang", @"历史页症状项标题：症状")];
        [cell.backView addSubview:headerLabel];
        startY += 30;
        NSMutableArray *namesArray = [[NSMutableArray alloc]init];
        for (NSArray *aSymptomType in symptomTypeArray)
        {
            NSString *typeId = [aSymptomType objectAtIndex:0];
            NSArray *symptomIds = [aSymptomType objectAtIndex:1];
            [namesArray addObjectsFromArray:[self getSymptomNamesForTypeId:typeId symptomId:symptomIds]];
        }
        NSString *text = [namesArray componentsJoinedByString:@","];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(270, 9999) lineBreakMode:UILineBreakModeWordWrap];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, startY, textSize.width, textSize.height)];
        textLabel.numberOfLines = 0;
        [textLabel setTextColor:[UIColor blackColor]];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        [textLabel setText:text];
        [cell.backView addSubview:textLabel];
        startY += textSize.height;
    }
    startY +=20;
    NSString *note = [record objectForKey:@"Note"];
    if (note != nil && [note length]>0)
    {
        UIImageView *sepLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, startY, 300, 1)];
        [cell.backView  addSubview:sepLine3];
        [sepLine3 setImage:[UIImage imageNamed:@"gray_horizon_line.png"]];
        [sepLine3 setContentMode:UIViewContentModeCenter];
        startY += 5;
        UILabel *headerLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, startY, 160, 20)];
        [headerLabel setFont:[UIFont systemFontOfSize:14]];
        [headerLabel setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:10.f]];
        [headerLabel setText:NSLocalizedString(@"lishi_c_biji", @"历史页笔记项标题：笔记")];
        [cell.backView addSubview:headerLabel];
        startY += 30;
        CGSize textSize = [note sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(270, 9999) lineBreakMode:UILineBreakModeWordWrap];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, startY, textSize.width, textSize.height)];
        textLabel.numberOfLines = 0;
        [textLabel setTextColor:[UIColor blackColor]];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        [textLabel setText:note];
        [cell.backView addSubview:textLabel];
        startY += textSize.height;
    }
    
    return cell;

}
-(NSString *)getTypeNameForTypeId:(NSString *)typeId
{
    NSString *typeName;
    NSString *queryKey;
    if (isChinese)
    {
        queryKey = @"SymptomTypeNameCn";
    }
    else
    {
        queryKey = @"SymptomTypeNameEn";
    }

    for (NSDictionary *typeDict in self.symptomTypeRows)
    {
        NSString *aId = [typeDict objectForKey:@"SymptomTypeId"];
        if ([aId isEqualToString:typeId])
        {
            typeName = [typeDict objectForKey:queryKey];
            break;
            
        }
    }
    return typeName;
}
-(NSArray *)getSymptomNamesForTypeId:(NSString *)typeId symptomId:(NSArray *)symptomIds
{
    NSSet *idSet = [NSSet setWithArray:symptomIds];
    NSArray *idArrays = [self.symptomRowsDict objectForKey:typeId];
    NSMutableArray *symptomNames = [[NSMutableArray alloc]init];
    NSString *queryKey;
    if (isChinese)
    {
        queryKey = @"SymptomNameCn";
    }
    else
    {
        queryKey = @"SymptomNameEn";
    }

    for (NSDictionary *sympDict in idArrays)
    {
        NSString *aId = [sympDict objectForKey:@"SymptomId"];
        if ([idSet containsObject:aId])
        {
            NSString *aName = [sympDict objectForKey:queryKey];
            [symptomNames addObject:aName];
        }
    }
    return symptomNames ;
    
}
-(NSString *)getIllnessText:(NSArray *)illnessIds
{
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *illnessArray = [da getIllness_ByIllnessIds:illnessIds];
    NSMutableArray *namesArray = [[NSMutableArray alloc]init];
    NSString *queryKey;
    if (isChinese)
    {
        queryKey =@"IllnessNameCn";
    }
    else
    {
        queryKey =@"IllnessNameEn";
    }
    for (NSDictionary *illnessDict in illnessArray)
    {
        NSString *illnessName =[illnessDict objectForKey:queryKey];

        [namesArray addObject:illnessName];
    }
    return [namesArray componentsJoinedByString:@","];
    
    
}
-(NSString *)getNutritionName:(NSString *)nutritionId
{
    LZNutrientionManager*nm = [LZNutrientionManager SharedInstance];
    NSDictionary *dict = [nm getNutritionInfo:nutritionId];
    //UIColor *backColor = [LZUtility getNutrientColorForNutrientId:nutritionId];
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
    NSString *converted = [LZUtility getNutritionNameInfo:nutritionName isChinese:isChinese];
    return converted;
    
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
    if (tableView == self.listView1)
    {
        NSDictionary *recordDict = [self.table1DataSource objectAtIndex:indexPath.section];
        return  [self calculateHeightForRecord:recordDict];
    }
    else if (tableView == self.listView2)
    {
        NSDictionary *recordDict = [self.table2DataSource objectAtIndex:indexPath.section];
        return  [self calculateHeightForRecord:recordDict];
    }
    else
    {
        NSDictionary *recordDict = [self.table3DataSource objectAtIndex:indexPath.section];
        return  [self calculateHeightForRecord:recordDict];
    }
}
-(float)calculateHeightForRecord:(NSDictionary *)recordDict
{
    //1.计算cell标题高度 固定的
    //2.计算第一部分高度 可变的有营养素 潜在疾病，没有为空
    //3.计算第二部分高度 根据用户所选症状，没有为空
    //4.计算第四部分高度，根据用户填写的数据，没有为空
    float otherHeight = 90;
    float part1Height = 0;
    float part2Height = 0;
    NSDictionary *inputNameValuePairs = [recordDict objectForKey:@"inputNameValuePairs"];
    NSArray *symptomTypeArray = [inputNameValuePairs objectForKey:Key_SymptomsByType];
    if (symptomTypeArray != nil && [symptomTypeArray count]!= 0)//有选择的症状
    {
        NSMutableArray *namesArray = [[NSMutableArray alloc]init];
        for (NSArray *aSymptomType in symptomTypeArray)
        {
            NSString *typeId = [aSymptomType objectAtIndex:0];
            NSArray *symptomIds = [aSymptomType objectAtIndex:1];
            [namesArray addObjectsFromArray:[self getSymptomNamesForTypeId:typeId symptomId:symptomIds]];
        }
        NSString *text = [namesArray componentsJoinedByString:@","];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(270, 9999) lineBreakMode:UILineBreakModeWordWrap];
        part1Height = textSize.height+55;
    }
    NSString *note = [recordDict objectForKey:@"Note"];
    if (note != nil && [note length]>0)
    {
        CGSize textSize = [note sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(270, 9999) lineBreakMode:UILineBreakModeWordWrap];
        part2Height = textSize.height +55;
    }
    return otherHeight+part1Height+part2Height;
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
-(NSString*)week:(NSInteger)week
{
    NSString*weekStr=nil;
    if(week==1)
    {
        weekStr=NSLocalizedString(@"lishi_c_zhouri", @"历史页周日：周日");
    }else if(week==2){
        weekStr=NSLocalizedString(@"lishi_c_zhouyi", @"历史页周日：周一");
        
    }else if(week==3){
        weekStr=NSLocalizedString(@"lishi_c_zhouer", @"历史页周日：周二");
        
    }else if(week==4){
        weekStr=NSLocalizedString(@"lishi_c_zhousan", @"历史页周日：周三");
        
    }else if(week==5){
        weekStr=NSLocalizedString(@"lishi_c_zhousi", @"历史页周日：周四");
        
    }else if(week==6){
        weekStr=NSLocalizedString(@"lishi_c_zhouwu", @"历史页周日：周五");
        
    }else if(week==7){
        weekStr=NSLocalizedString(@"lishi_c_zhouliu", @"历史页周日：周六");
        
    }
    return weekStr;
}
-(NSString *)bmiLevel:(double)bmiValue
{
    if (bmiValue<18.5)
    {
        return NSLocalizedString(@"jiankangbaogao_c_guoqing", @"体质指数范围：过轻");
    }
    else if (bmiValue>=18.5 && bmiValue<25)
    {
        return NSLocalizedString(@"jiankangbaogao_c_zhengchang", @"体质指数范围：正常");
    }
    else if (bmiValue >= 25 && bmiValue <30)
    {
        return NSLocalizedString(@"jiankangbaogao_c_guozhong", @"体质指数范围：过重");
    }
    else
    {
        return NSLocalizedString(@"jiankangbaogao_c_feipang", @"体质指数范围：肥胖");
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView)
    {
        CGSize pageSize = scrollView.frame.size;
        int page = floor(scrollView.contentOffset.x / pageSize.width);
        
        if (page < 0 || page >= totalPage || page == currentPage)
        {
            return;
        }
        currentPage = page;
        [self displayContentForPage:currentPage];
    }
    
    //[self.photoScrollView setContentOffset:CGPointMake(self.view.bounds.size.width  * currentPhotoIndex, 0)];
}

@end
