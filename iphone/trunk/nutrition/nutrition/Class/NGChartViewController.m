//
//  NGChartViewController.m
//  nutrition
//
//  Created by liu miao on 12/11/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGChartViewController.h"
#import "LZDataAccess.h"
#import "LZUtility.h"
#import "LZConstants.h"
@interface NGChartViewController ()
@property (nonatomic, assign)int currentPage;
@property (nonatomic, assign) ScatterType currentScatterType;
@property (nonatomic,strong)NSArray *distinctMonthsArray;
@property (nonatomic,assign)int totalPage;
@property (nonatomic,strong)NSMutableDictionary *historyDict;

@end

@implementation NGChartViewController
@synthesize chart1Controller,chart2Controller,chart3Controller,currentPage,currentScatterType,totalPage,historyDict,distinctMonthsArray;
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
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect contentRect = CGRectMake(0, 0, screenSize.width, screenSize.height - 64-49-self.contentTypeChangeControl.frame.size.height);
    chart1Controller = [[LZScatterViewController alloc]init];
    [chart1Controller configureScatterView:contentRect];
    
    chart2Controller = [[LZScatterViewController alloc]init];
    [chart2Controller configureScatterView:contentRect];
    
    chart3Controller = [[LZScatterViewController alloc]init];
    [chart3Controller configureScatterView:contentRect];
    self.title = NSLocalizedString(@"tubiao_c_title", @"页面标题：图表");
	// Do any additional setup after loading the view.
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltoprevious)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltonext)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.contentTypeChangeControl setTitle:NSLocalizedString(@"tubiao_c_yingyang", @"营养项标题：营养") forSegmentAtIndex:0];
    [self.contentTypeChangeControl setTitle:NSLocalizedString(@"tubiao_c_tizhi", @"体质项标题：体质") forSegmentAtIndex:1];
    [self.contentTypeChangeControl setTitle:NSLocalizedString(@"tubiao_c_tizhong", @"体重项标题：体重") forSegmentAtIndex:2];
    [self.contentTypeChangeControl setTitle:NSLocalizedString(@"tubiao_c_tiwen", @"体温项标题：体温") forSegmentAtIndex:3];
    [self.contentTypeChangeControl setTitle:NSLocalizedString(@"tubiao_c_xueya", @"血压项标题：血压") forSegmentAtIndex:4];
    [self.contentTypeChangeControl setTitle:NSLocalizedString(@"tubiao_c_xintiao", @"心跳项标题：心跳") forSegmentAtIndex:5];
    [self initialize];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(historyUpdated:) name: Notification_HistoryUpdatedKey object:nil];
}
-(void)historyUpdated:(NSNotification *)notification
{
    [self initialize];
}
-(void)initialize
{
    currentScatterType = ScatterTypeNI;
    
    [self.contentTypeChangeControl setSelectedSegmentIndex:0];
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
    chart1Controller.scatterType = currentScatterType;
    chart2Controller.scatterType = currentScatterType;
    chart3Controller.scatterType = currentScatterType;
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
            [self.contentScrollView addSubview:self.chart1Controller.view];
            [self.chart1Controller.view setFrame:CGRectMake(0, 0, 320,height )];
            NSNumber *startLocal = [distinctMonthsArray objectAtIndex:0];
            self.navigationItem.title = [NSString stringWithFormat:@"%d.%d",[startLocal intValue]/100,[startLocal intValue]%100];
            self.chart1Controller.dataForPlot = [self getDataSourceForMonthLocal:[startLocal intValue]];
            [self.chart1Controller reloadData];
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
            
            [self.contentScrollView addSubview:self.chart1Controller.view];
            //update dataSource
            [self.chart1Controller.view setFrame:CGRectMake(currentPage*320, 0, 320, height)];
            self.chart1Controller.dataForPlot =[self getDataSourceForMonthLocal:currentLocal];
            [self.chart1Controller reloadData];
            [self.chart2Controller.view setFrame:CGRectMake((currentPage+1)*320, 0, 320,height)];
            self.chart2Controller.dataForPlot = [self getDataSourceForMonthLocal:nextLocal];
            [self.chart2Controller reloadData];
        }
        else if (currentPage == totalPage-1)
        {
            int index = currentPage%3;
            CGRect currentRect = CGRectMake(currentPage*320, 0, 320, height);
            CGRect preRect = CGRectMake((currentPage-1)*320, 0, 320, height);
            if (index == 0)
            {
                [self.contentScrollView addSubview:self.chart1Controller.view];
                [self.chart1Controller.view setFrame:currentRect];
                
                self.chart1Controller.dataForPlot = [self getDataSourceForMonthLocal:currentLocal];
                [self.chart1Controller reloadData];
                [self.contentScrollView addSubview:self.chart3Controller.view];
                [self.chart3Controller.view setFrame:preRect];
                self.chart3Controller.dataForPlot =[self getDataSourceForMonthLocal:preLoacal];
                [self.chart3Controller reloadData];
            }
            else if (index == 1)
            {
                [self.contentScrollView addSubview:self.chart2Controller.view];
                [self.chart2Controller.view setFrame:currentRect];
                
                self.chart2Controller.dataForPlot =  [self getDataSourceForMonthLocal:currentLocal];
                [self.chart2Controller reloadData];
                [self.contentScrollView addSubview:self.chart1Controller.view];
                [self.chart1Controller.view setFrame:preRect];
                self.chart1Controller.dataForPlot =  [self getDataSourceForMonthLocal:preLoacal];
                [self.chart1Controller reloadData];
            }
            else
            {
                [self.contentScrollView addSubview:self.chart3Controller.view];
                [self.chart3Controller.view setFrame:currentRect];
                self.chart3Controller.dataForPlot = [self getDataSourceForMonthLocal:currentLocal];
                [self.chart3Controller reloadData];
                [self.contentScrollView addSubview:self.chart2Controller.view];
                [self.chart2Controller.view setFrame:preRect];
                self.chart2Controller.dataForPlot = [self getDataSourceForMonthLocal:preLoacal];
                [self.chart2Controller reloadData];
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
            [self.contentScrollView addSubview:self.chart1Controller.view];
            [self.contentScrollView addSubview:self.chart2Controller.view];
            [self.contentScrollView addSubview:self.chart3Controller.view];
            if (index == 0)
            {
                [self.chart1Controller.view setFrame:currentRect];
                [self.chart2Controller.view setFrame:nextRect];
                [self.chart3Controller.view setFrame:preRect];
                self.chart1Controller.dataForPlot =[self getDataSourceForMonthLocal:currentLocal];
                [self.chart1Controller reloadData];
                
                self.chart2Controller.dataForPlot =[self getDataSourceForMonthLocal:nextLocal];
                [self.chart2Controller reloadData];
                
                self.chart3Controller.dataForPlot =[self getDataSourceForMonthLocal:preLoacal];
                [self.chart3Controller reloadData];
                
            }
            else if (index == 1)
            {
                [self.chart1Controller.view setFrame:preRect];
                [self.chart2Controller.view setFrame:currentRect];
                [self.chart3Controller.view setFrame:nextRect];
                self.chart1Controller.dataForPlot =[self getDataSourceForMonthLocal:preLoacal];
                [self.chart1Controller reloadData];
                
                self.chart2Controller.dataForPlot =[self getDataSourceForMonthLocal:currentLocal];
                [self.chart2Controller reloadData];
                
                self.chart3Controller.dataForPlot =[self getDataSourceForMonthLocal:nextLocal];
                [self.chart3Controller reloadData];
            }
            else
            {
                [self.chart1Controller.view setFrame:nextRect];
                [self.chart2Controller.view setFrame:preRect];
                [self.chart3Controller.view setFrame:currentRect];
                self.chart1Controller.dataForPlot =[self getDataSourceForMonthLocal:nextLocal];
                [self.chart1Controller reloadData];
                
                self.chart2Controller.dataForPlot =[self getDataSourceForMonthLocal:preLoacal];
                [self.chart2Controller reloadData];
                
                self.chart3Controller.dataForPlot =[self getDataSourceForMonthLocal:currentLocal];
                [self.chart3Controller reloadData];
            }
            [self.navigationItem.leftBarButtonItem setEnabled:YES];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }
    }
}

- (NSArray *)plotDataSourceForTesting
{
    if (currentScatterType == ScatterTypeBP) {
        NSMutableArray *lbpArray = [NSMutableArray arrayWithCapacity:POINTS_COUNT];
        NSMutableArray *hbpArray = [NSMutableArray arrayWithCapacity:POINTS_COUNT];
        for (NSInteger i = 0; i < 2; i++) {
            for (NSInteger j = 0; j < POINTS_COUNT; j++) {
                int day = j + 1;
                NSNumber *x = [NSNumber numberWithInteger:day];
                int lowerBound, upperBound;
                if (i == 0) {
                    lowerBound = 70;
                    upperBound = 100;
                }
                else {
                    lowerBound = 150;
                    upperBound = 180;
                }
                int randomValue = lowerBound + arc4random() % (upperBound - lowerBound);
                NSNumber *y = [NSNumber numberWithFloat:randomValue];
                NSLog(@"%@", y);
                if (i == 0) {
                    [lbpArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
                }
                else {
                    [hbpArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
                }
            }
        }
        NSArray *bpArray = @[lbpArray, hbpArray];
        return bpArray;
    }
    else {
        NSMutableArray *dataForPlot = [NSMutableArray arrayWithCapacity:POINTS_COUNT];
        dataForPlot = [NSMutableArray arrayWithCapacity:POINTS_COUNT];
        for (NSInteger i = 0; i < POINTS_COUNT; i++) {
            int day = i + 1;
            NSNumber *x = [NSNumber numberWithInteger:day];
            NSNumber *y;
            if (currentScatterType == ScatterTypeBMI) {
                int lowerBound = 21;
                int upperBound = 23;
                float randomValue = lowerBound + arc4random() % (upperBound - lowerBound) + 0.2f;
                y = [NSNumber numberWithFloat:randomValue];
                NSLog(@"%@", y);
            }
            else if (currentScatterType == ScatterTypeTemperature) {
                int lowerBound = 36.5;
                int upperBound = 37.5;
                float randomValue = lowerBound + arc4random() % (upperBound - lowerBound) + 0.2f;
                y = [NSNumber numberWithFloat:randomValue];
                NSLog(@"%@", y);
            }
            else if (currentScatterType == ScatterTypeNI) {
                int lowerBound = 80;
                int upperBound = 90;
                float randomValue = lowerBound + arc4random() % (upperBound - lowerBound);
                y = [NSNumber numberWithFloat:randomValue];
                NSLog(@"%@", y);
            }
            else if (currentScatterType == ScatterTypeHeartbeat) {
                int lowerBound = 50;
                int upperBound = 70;
                float randomValue = lowerBound + arc4random() % (upperBound - lowerBound);
                y = [NSNumber numberWithFloat:randomValue];
                NSLog(@"%@", y);
            }
            else if (currentScatterType == ScatterTypeWeight) {
                int lowerBound = 65;
                int upperBound = 70;
                float randomValue = lowerBound + arc4random() % (upperBound - lowerBound);
                y = [NSNumber numberWithFloat:randomValue];
                NSLog(@"%@", y);
            }
            else
                y = [NSNumber numberWithInt:5 + i * 5];
            [dataForPlot addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
        }
        return dataForPlot;
    }
}

-(NSArray *)getDataSourceForMonthLocal:(int)monthLocal
{
    return [self plotDataSourceForTesting];
    
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
            return [self getArrayForType:currentScatterType data:thisData];
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
}
-(void)scrolltonext
{
    currentPage = currentPage+1;
    [self displayContentForPage:currentPage];
}
- (IBAction)contentTypeChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0)//营养
    {
        currentScatterType = ScatterTypeNI;
    }
    else if(sender.selectedSegmentIndex == 1)//体质
    {
        currentScatterType = ScatterTypeBMI;
    }
    else if(sender.selectedSegmentIndex == 2)//体重
    {
        currentScatterType = ScatterTypeWeight;
    }
    else if(sender.selectedSegmentIndex == 3)//体温
    {
        currentScatterType = ScatterTypeTemperature;
    }
    else if(sender.selectedSegmentIndex == 4)//血压 有高压和低压两条线
    {
        currentScatterType = ScatterTypeBP;
    }
    else//心跳
    {
        currentScatterType = ScatterTypeHeartbeat;
    }
    [self displayContentForPage:currentPage];
    
}
//-(void)updateChartDataSource:(ScatterType)scatterType
//{
//    
//    LZDataAccess *da = [LZDataAccess singleton];
//    
//    int thisMonthLocal = [LZUtility getMonthLocalForDistance:currentPage startLocal:201314];
//    
//    int thisStartLocal = thisMonthLocal*100+1;
//    int thisEndLocal = thisMonthLocal*100+32;
//    NSArray *thisData = [da getUserRecordSymptomDataByRange_withStartDayLocal:thisStartLocal andEndDayLocal:thisEndLocal andStartMonthLocal:0 andEndMonthLocal:0];
//    NSArray *thisDataSource = [self getArrayForType:currentScatterType data:thisData];
//
//    int preMonthLocal = [LZUtility getMonthLocalForDistance:currentPage-1 startLocal:201314];
//    int preStartLocal = preMonthLocal*100+1;
//    int preEndLocal = preMonthLocal*100+32;
//    NSArray *preData = [da getUserRecordSymptomDataByRange_withStartDayLocal:preStartLocal andEndDayLocal:preEndLocal andStartMonthLocal:0 andEndMonthLocal:0];
//    NSArray *preDataSource = [self getArrayForType:currentScatterType data:preData];
//    
//    int nextMonthLocal = [LZUtility getMonthLocalForDistance:currentPage+1 startLocal:201314];
//    int nextStartLocal = nextMonthLocal*100+1;
//    int nextEndLocal = nextMonthLocal*100+32;
//    NSArray *nextData = [da getUserRecordSymptomDataByRange_withStartDayLocal:nextStartLocal andEndDayLocal:nextEndLocal andStartMonthLocal:0 andEndMonthLocal:0];
//    NSArray *nextDataSource = [self getArrayForType:currentScatterType data:nextData];
//    //we set data source accroding to the view content type and current page
//    int index = currentPage;
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
//    if (newIndex%3 == 0)
//    {
//        self.chart1Controller.dataForPlot = thisDataSource;
//        self.chart3Controller.dataForPlot = preDataSource;
//        self.chart2Controller.dataForPlot = nextDataSource;
//        //[self.chart1Controller.view reloadData];
//        //return self.chart1Controller.view;
//        
//    }
//    else if(newIndex%3 == 1)
//    {
//        self.chart2Controller.dataForPlot = thisDataSource;
//        self.chart1Controller.dataForPlot = preDataSource;
//        self.chart3Controller.dataForPlot = nextDataSource;
//        //return self.chart2Controller.view;
//        
//    }
//    else
//    {
//        self.chart3Controller.dataForPlot = thisDataSource;
//        self.chart2Controller.dataForPlot = preDataSource;
//        self.chart1Controller.dataForPlot = nextDataSource;
//        //return self.chart3Controller.view;
//    }
//
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didChangeToPage:(NSInteger)index
{
    currentPage = index;
    NSLog(@"did change to %d",index);
}
-(NSArray *)getArrayForType:(ScatterType)scatterType data:(NSArray *)data
{
    if (data == nil || [data count]==0)
    {
        return nil;
    }

    if (scatterType == ScatterTypeBP)
    {
        NSMutableArray *lbpArray = [[NSMutableArray alloc]init];
        NSMutableArray *hbpArray = [[NSMutableArray alloc]init];
        for ( NSDictionary *dict in data)
        {
            NSNumber *dayLocal = [dict objectForKey:@"DayLocal"];
            int x = [dayLocal intValue]%100;
            NSDictionary *inputNameValuePairs = [dict objectForKey:@"inputNameValuePairs"];
            NSNumber *bloodPressureLow = [inputNameValuePairs objectForKey:Key_BloodPressureLow];
            NSNumber *bloodPressureHigh = [inputNameValuePairs objectForKey:Key_BloodPressureHigh];
            if (bloodPressureLow != nil)
            {
                [lbpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:x],@"x",bloodPressureLow,@"y" ,nil]];
            }
            if (bloodPressureHigh != nil)
            {
                [hbpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:x],@"x",bloodPressureHigh,@"y" ,nil]];
            }

        }
        NSArray *bpArray = @[lbpArray, hbpArray];
        return bpArray;
    }
    else
    {
        NSMutableArray *dataSource = [[NSMutableArray alloc]init];
        for ( NSDictionary *dict in data)
        {
            NSNumber *dayLocal = [dict objectForKey:@"DayLocal"];
            NSDictionary *calculateNameValuePairs = [dict objectForKey:@"calculateNameValuePairs"];
            NSDictionary *inputNameValuePairs = [dict objectForKey:@"inputNameValuePairs"];
            int x = [dayLocal intValue]%100;
            if (scatterType == ScatterTypeNI)
            {
                NSNumber *ni = [calculateNameValuePairs objectForKey:Key_HealthMark];
                if (ni != nil)
                {
                    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:x],@"x",ni,@"y" ,nil]];
                }
            }
            else if (scatterType == ScatterTypeBMI)
            {
                NSNumber *bmi = [calculateNameValuePairs objectForKey:Key_BMI];
                if (bmi != nil)
                {
                    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:x],@"x",bmi,@"y" ,nil]];
                }
            }
            else if (scatterType == ScatterTypeWeight)
            {
                NSNumber *weight = [inputNameValuePairs objectForKey:Key_Weight];
                if (weight != nil)
                {
                    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:x],@"x",weight,@"y" ,nil]];
                }
            }
            else if (scatterType == ScatterTypeTemperature)
            {
                NSNumber *temperature = [inputNameValuePairs objectForKey:Key_BodyTemperature];
                if (temperature != nil)
                {
                    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:x],@"x",temperature,@"y" ,nil]];
                }
            }
            else// if (scatterType == ScatterTypeHeartbeat)
            {
                NSNumber *heartRate = [inputNameValuePairs objectForKey:Key_HeartRate];
                if (heartRate != nil)
                {
                    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:x],@"x",heartRate,@"y" ,nil]];
                }
            }
        }
        return dataSource;
    }
    
}
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
