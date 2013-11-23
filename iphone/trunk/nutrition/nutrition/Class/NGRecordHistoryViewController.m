//
//  NGRecordHistoryViewController.m
//  nutrition
//
//  Created by liu miao on 11/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGRecordHistoryViewController.h"

@interface NGRecordHistoryViewController ()


@end

@implementation NGRecordHistoryViewController

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
}
-(void)viewDidAppear:(BOOL)animated
{
    if (IOS7_OR_LATER)
    {
        [self.listView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [self.listView setSectionIndexTrackingBackgroundColor :[UIColor whiteColor]];
        [self.listView setSectionIndexColor:[UIColor blackColor]];
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
    UITableViewCell *cell = [self.listView dequeueReusableCellWithIdentifier:@"RecordCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"section%d ",indexPath.section];
    
    return cell;
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
    return 120;
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

@end
