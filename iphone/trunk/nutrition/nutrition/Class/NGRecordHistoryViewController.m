//
//  NGRecordHistoryViewController.m
//  nutrition
//
//  Created by liu miao on 11/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGRecordHistoryViewController.h"
#import "NGRecordCell.h"
@interface NGRecordHistoryViewController ()
@property (nonatomic,strong)NGCycleScrollView* cycleView;
@end

@implementation NGRecordHistoryViewController
@synthesize cycleView;
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
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
	// Do any additional setup after loading the view.
    cycleView = [[NGCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - 64-49)];
    [self.listView1 setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - 64-49)];
    [self.listView2 setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - 64-49)];
    [self.listView3 setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - 64-49)];
    self.cycleView.delegate = self;
    self.cycleView.datasource = self;
    [self.view addSubview:cycleView];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"上一个" style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltoprevious)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"下一个" style:UIBarButtonItemStyleBordered target:self action:@selector(scrolltonext)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)scrolltoprevious
{
    [self.cycleView scrollToPreviousPage];
}
-(void)scrolltonext
{
    [self.cycleView scrollToNextPage];
}
-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (IOS7_OR_LATER)
    {
        [self.listView1 setSectionIndexBackgroundColor:[UIColor clearColor]];
        [self.listView1 setSectionIndexTrackingBackgroundColor :[UIColor whiteColor]];
        [self.listView2 setSectionIndexBackgroundColor:[UIColor clearColor]];
        [self.listView2 setSectionIndexTrackingBackgroundColor :[UIColor whiteColor]];
        [self.listView3 setSectionIndexBackgroundColor:[UIColor clearColor]];
        [self.listView3 setSectionIndexTrackingBackgroundColor :[UIColor whiteColor]];
        //[self.listView setSectionIndexColor:[UIColor blackColor]];
    }
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
        cell.textLabel.text = @"1";
        return cell;
    }
    else if(tableView == self.listView2)
    {
        NGRecordCell *cell = (NGRecordCell*)[self.listView2 dequeueReusableCellWithIdentifier:@"NGRecordCell"];
        cell.textLabel.text = @"2";
        return cell;
    }
    else
    {
        NGRecordCell *cell = (NGRecordCell*)[self.listView3 dequeueReusableCellWithIdentifier:@"NGRecordCell"];
        cell.textLabel.text = @"3";
        return cell;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 15;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
//
//// Editing


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
// return list of section titles to display in section index view (e.g. "ABCD...Z#")
{
    NSMutableArray *titleArray = [NSMutableArray array];
    for (int i =0 ; i<15; i++)
    {
        [titleArray addObject:[NSString stringWithFormat:@"%d",i]];
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
- (UIView *)pageAtIndex:(NSInteger)index
{
    UIView *newView = [[UIView alloc]initWithFrame:cycleView.bounds];
    [newView setBackgroundColor:[UIColor clearColor]];
    if (index%3 == 0)
    {
        
        [newView addSubview:self.listView1];
        [self.listView1 reloadData];
        
    }
    else if(index%3 == 1)
    {
        [newView addSubview:self.listView2];
        [self.listView2 reloadData];

    }
    else
    {
        [newView addSubview:self.listView3];
        [self.listView3 reloadData];

    }
    return  newView;
}
@end
