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
@property (nonatomic,strong)NGCycleScrollView* cycleView;
@property (nonatomic,assign)CGRect contentRect;
@property (nonatomic, assign)int currentPage;
@property (nonatomic, assign) ScatterType currentScatterType;

@end

@implementation NGChartViewController
@synthesize cycleView,contentRect,chart1Controller,chart2Controller,chart3Controller,currentPage,currentScatterType;
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
    contentRect = CGRectMake(0, self.contentTypeChangeControl.frame.size.height, screenSize.width, screenSize.height - 64-49-self.contentTypeChangeControl.frame.size.height);
    cycleView = [[NGCycleScrollView alloc] initWithFrame:contentRect];

    [self.view addSubview:cycleView];
    chart1Controller = [[LZScatterViewController alloc]init];
    [chart1Controller configureScatterView:cycleView.bounds];
    NSLog(@"%f %f %f %f ",cycleView.bounds.origin.x,cycleView.bounds.origin.y,cycleView.bounds.size.width,cycleView.bounds.size.height);
    
    chart2Controller = [[LZScatterViewController alloc]init];
    [chart2Controller configureScatterView:cycleView.bounds];
    
    chart3Controller = [[LZScatterViewController alloc]init];
    [chart3Controller configureScatterView:cycleView.bounds];
    cycleView.delegate = self;
    cycleView.datasource = self;
    currentPage = 0;
	// Do any additional setup after loading the view.
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltoprevious)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltonext)];
    self.navigationItem.rightBarButtonItem = rightItem;
    LZDataAccess *da = [LZDataAccess singleton];
//    NSArray *array = [da getUserRecordSymptom_DistinctMonth];
    currentScatterType = ScatterTypeNI;
    //-(NSArray*)getUserRecordSymptomDataByRange_withStartDayLocal:(int)StartDayLocal andEndDayLocal:(int)EndDayLocal andStartMonthLocal:(int)StartMonthLocal andEndMonthLocal:(int)EndMonthLocal;
    
    
}
-(void)scrolltoprevious
{
    NSLog(@"%@",self.cycleView.scrollView.subviews);
    [self.cycleView scrollToPreviousPage];
}
-(void)scrolltonext
{
    NSLog(@"%@",self.cycleView.scrollView.subviews);
    [self.cycleView scrollToNextPage];
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
    self.chart1Controller.scatterType = currentScatterType;
    self.chart2Controller.scatterType = currentScatterType;
    self.chart3Controller.scatterType = currentScatterType;
    [self updateChartDataSource:currentScatterType];
    [self.chart1Controller reloadData];
    [self.chart2Controller reloadData];
    [self.chart3Controller reloadData];
    
}
-(void)updateChartDataSource:(ScatterType)scatterType
{
    
    LZDataAccess *da = [LZDataAccess singleton];
    
    int thisMonthLocal = [LZUtility getMonthLocalForDistance:currentPage];
    
    int thisStartLocal = thisMonthLocal*100+1;
    int thisEndLocal = thisMonthLocal*100+32;
    NSArray *thisData = [da getUserRecordSymptomDataByRange_withStartDayLocal:thisStartLocal andEndDayLocal:thisEndLocal andStartMonthLocal:0 andEndMonthLocal:0];
    NSArray *thisDataSource = [self getArrayForType:currentScatterType data:thisData];

    int preMonthLocal = [LZUtility getMonthLocalForDistance:currentPage-1];
    int preStartLocal = preMonthLocal*100+1;
    int preEndLocal = preMonthLocal*100+32;
    NSArray *preData = [da getUserRecordSymptomDataByRange_withStartDayLocal:preStartLocal andEndDayLocal:preEndLocal andStartMonthLocal:0 andEndMonthLocal:0];
    NSArray *preDataSource = [self getArrayForType:currentScatterType data:preData];
    
    int nextMonthLocal = [LZUtility getMonthLocalForDistance:currentPage+1];
    int nextStartLocal = nextMonthLocal*100+1;
    int nextEndLocal = nextMonthLocal*100+32;
    NSArray *nextData = [da getUserRecordSymptomDataByRange_withStartDayLocal:nextStartLocal andEndDayLocal:nextEndLocal andStartMonthLocal:0 andEndMonthLocal:0];
    NSArray *nextDataSource = [self getArrayForType:currentScatterType data:nextData];
    //we set data source accroding to the view content type and current page
    int index = currentPage;
    int newIndex;
    if (index <0)
    {
        int i;
        for (i=1; i*3+index<0; i++)
        {
        }
        newIndex = i*3+index;
        
    }
    else
    {
        newIndex = index;
    }
    if (newIndex%3 == 0)
    {
        self.chart1Controller.dataForPlot = thisDataSource;
        self.chart3Controller.dataForPlot = preDataSource;
        self.chart2Controller.dataForPlot = nextDataSource;
        //[self.listView1 reloadData];
        //return self.chart1Controller.view;
        
    }
    else if(newIndex%3 == 1)
    {
        self.chart2Controller.dataForPlot = thisDataSource;
        self.chart1Controller.dataForPlot = preDataSource;
        self.chart3Controller.dataForPlot = nextDataSource;
        //return self.chart2Controller.view;
        
    }
    else
    {
        self.chart3Controller.dataForPlot = thisDataSource;
        self.chart2Controller.dataForPlot = preDataSource;
        self.chart1Controller.dataForPlot = nextDataSource;
        //return self.chart3Controller.view;
    }

}
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
                NSNumber *temperature = [inputNameValuePairs objectForKey:Key_Temperature];
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
- (UIView *)pageAtIndex:(NSInteger)index
{
    LZDataAccess *da = [LZDataAccess singleton];

    int thisMonthLocal = [LZUtility getMonthLocalForDistance:index];
    
    if (index == currentPage)
    {
        NSString *title = [NSString stringWithFormat:@"%d.%d",thisMonthLocal/100,thisMonthLocal%100];
        self.title = title;
    }
    
    int startLocal = thisMonthLocal*100+1;
    int endLocal = thisMonthLocal*100+32;
    NSArray *data = [da getUserRecordSymptomDataByRange_withStartDayLocal:startLocal andEndDayLocal:endLocal andStartMonthLocal:0 andEndMonthLocal:0];
    NSArray *dataSource = [self getArrayForType:currentScatterType data:data];
    UIView *newView = [[UIView alloc]initWithFrame:cycleView.bounds];
    [newView setBackgroundColor:[UIColor clearColor]];
    int newIndex;
    if (index <0)
    {
        int i;
        for (i=1; i*3+index<0; i++)
        {
        }
        newIndex = i*3+index;
        
    }
    else
    {
        newIndex = index;
    }
    NSLog(@"require %d",index);
    if (newIndex%3 == 0)
    {
        self.chart1Controller.dataForPlot = dataSource;
        [self.chart1Controller reloadData];
        [newView addSubview:self.chart1Controller.view];
        //[self.listView1 reloadData];
        //return self.chart1Controller.view;
        
    }
    else if(newIndex%3 == 1)
    {
        self.chart2Controller.dataForPlot = dataSource;
        [self.chart2Controller reloadData];
        [newView addSubview:self.chart2Controller.view];
        //return self.chart2Controller.view;
        
    }
    else
    {
        self.chart3Controller.dataForPlot = dataSource;
        [self.chart3Controller reloadData];
        [newView addSubview:self.chart3Controller.view];
        //return self.chart3Controller.view;
        
    }
    return  newView;
}

@end
