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
@synthesize foodIntakeAmountArray,foodNameArray;
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
    //获取食物名称 初始化foodNameArray 和 foodIntakeAmountArray
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    //cell.foodNameLabel.text = [self.foodNameArray objectAtIndex:indexPath.row];
    //cell.intakeAmountTextField.text = [self.foodIntakeAmountArray objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)saveButtonTapped:(id)sender {
    //储存摄入量
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)resetButtonTapped:(id)sender {
    //clear foodIntakeAmountArray
    //[self.foodIntakeAmountArray removeAllObjects];
    [self.listView reloadData];
}
- (void)textFieldDidReturnForIndex:(NSIndexPath*)index andText:(NSString*)foodNumber
{
    //[self.foodIntakeAmountArray replaceObjectAtIndex:index.row withObject:foodNumber];
    NSLog(@"cell section %d , row %d food amount %@",index.section,index.row,foodNumber);
}
- (void)keyboardWillShow:(NSNotification *)notification {
	
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *boundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [boundsValue CGRectValue];
    
    CGFloat keyboardTop = self.view.frame.size.height - keyboardRect.size.height;
    CGRect tableviewFrame = self.listView.frame;
	tableviewFrame.size.height = keyboardTop;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
	CGRect tableviewFrame = self.listView.frame;
	tableviewFrame.size.height = self.view.frame.size.height;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
