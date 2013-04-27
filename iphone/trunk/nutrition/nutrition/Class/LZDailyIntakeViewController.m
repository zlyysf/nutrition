//
//  LZDailyIntakeViewController.m
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDailyIntakeViewController.h"
#import "LZFoodCell.h"
@interface LZDailyIntakeViewController ()<LZFoodCellDelegate>

@end

@implementation LZDailyIntakeViewController

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZFoodCell* cell =[tableView dequeueReusableCellWithIdentifier:@"FoodCell"];
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    //一个记录名称的数组 一个记录对应摄入量的数组
    return cell;
}

- (IBAction)saveButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)resetButtonTapped:(id)sender {
    //clear 用量数组
    [self.listView reloadData];
}
- (void)textFieldDidReturnForIndex:(NSIndexPath*)index
{
    NSLog(@"cell section %d , row %d",index.section,index.row);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
