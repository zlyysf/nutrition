//
//  NGChartViewController.m
//  nutrition
//
//  Created by liu miao on 12/11/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGChartViewController.h"

@interface NGChartViewController ()
@property (nonatomic,strong)NGCycleScrollView* cycleView;
@property (nonatomic,assign)CGRect contentRect;
@end

@implementation NGChartViewController
@synthesize cycleView,contentRect,chart1Controller,chart2Controller,chart3Controller;
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
	// Do any additional setup after loading the view.
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"上一个" style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltoprevious)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"下一个" style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltonext)];
    self.navigationItem.rightBarButtonItem = rightItem;
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
    self.chart1Controller.scatterType = ScatterTypeBMI;
    self.chart2Controller.scatterType = ScatterTypeBMI;
    self.chart3Controller.scatterType = ScatterTypeBMI;
    [self.chart1Controller reloadData];
    [self.chart2Controller reloadData];
    [self.chart3Controller reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didChangeToPage:(NSInteger)index
{
    NSLog(@"did change to %d",index);
}
- (UIView *)pageAtIndex:(NSInteger)index
{
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
        self.chart1Controller.scatterType = ScatterTypeNI;
        [newView addSubview:self.chart1Controller.view];
        //[self.listView1 reloadData];
        //return self.chart1Controller.view;
        
    }
    else if(newIndex%3 == 1)
    {
        self.chart2Controller.scatterType = ScatterTypeNI;
        [newView addSubview:self.chart2Controller.view];
        //return self.chart2Controller.view;
        
    }
    else
    {
        self.chart3Controller.scatterType = ScatterTypeNI;
        [newView addSubview:self.chart3Controller.view];
        //return self.chart3Controller.view;
        
    }
    return  newView;
}

@end
