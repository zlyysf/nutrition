//
//  LZAddByNutrientController.m
//  nutrition
//
//  Created by liu miao on 6/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZAddByNutrientController.h"
#import "LZConstants.h"
#import <math.h>
@interface LZAddByNutrientController ()

@end

@implementation LZAddByNutrientController
@synthesize foodArray,currentFoodInputTextField,nutrientTitle,tempIntakeDict;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 300, 36)];
    tipsLabel.numberOfLines = 2;
    [tipsLabel setFont:[UIFont systemFontOfSize:15]];
    [tipsLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f]];
    tipsLabel.text = [NSString stringWithFormat:@"下列是富含%@的食物，您可以根据我们提供的推荐量来挑选适合自己的食物。", nutrientTitle];
    tempIntakeDict = [[NSMutableDictionary alloc]init];
    [tipsLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:tipsLabel];
    self.listView.tableHeaderView = headerView;
    self.navItem.title = nutrientTitle;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.foodArray count];
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZNutrientFoodAddCell* cell =(LZNutrientFoodAddCell*)[tableView dequeueReusableCellWithIdentifier:@"LZNutrientFoodAddCell"];
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    //一个记录名称的数组 一个记录对应摄入量的数组
    NSDictionary *aFood = [self.foodArray objectAtIndex:indexPath.row];
    NSLog(@"picture path food list %@",aFood);
    NSString *picturePath;
    NSString *picPath = [aFood objectForKey:@"PicPath"];
    if (picPath == nil || [picPath isEqualToString:@""])
    {
        picturePath = [[NSBundle mainBundle]pathForResource:@"defaulFoodPic" ofType:@"png"];
    }
    else
    {
        picturePath = [NSString stringWithFormat:@"%@/foodDealed/%@",[[NSBundle mainBundle] bundlePath],picPath];
    }
    UIImage *foodImage = [UIImage imageWithContentsOfFile:picturePath];
    [cell.foodPicView setImage:foodImage];
    
    cell.foodNameLabel.text = [aFood objectForKey:@"CnCaption"];//NDB_No
    NSString *NDB_No = [aFood objectForKey:@"NDB_No"];
    NSNumber *foodAmount = [aFood objectForKey:Key_FoodAmount];
    NSNumber *intake= [self.tempIntakeDict objectForKey:NDB_No];
    int amount =(int)(ceilf([foodAmount floatValue]));
    cell.recommendAmountLabel.text = [NSString stringWithFormat:@"推荐量:%dg",amount];
    UIImage *textImage = [UIImage imageNamed:@"setting_text_back.png"];
    UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    [cell.textFiledBackImage setImage:textBackImage];
    int num = [intake intValue];
    if(num == 0)
    {
       cell.intakeAmountTextField.text = @"";
    }
    else
    {
        cell.intakeAmountTextField.text = [NSString stringWithFormat:@"%d",num];
    }
    
    [cell.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
    return cell;
}
- (IBAction)cancelButtonTapped:(id)sender
{
    [tempIntakeDict removeAllObjects];
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)saveButtonTapped:(id)sender {
    //储存摄入量
    if(self.currentFoodInputTextField != nil)
    {
        [self.currentFoodInputTextField resignFirstResponder];
    }
    NSMutableDictionary *intakeDict = [[NSMutableDictionary alloc]init];
    NSDictionary *dailyIntake = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
    if(dailyIntake != nil)
    {
        [intakeDict addEntriesFromDictionary:dailyIntake];
    }
    
    BOOL needSaveData = NO;
    for (NSString * NDB_No in [self.tempIntakeDict allKeys])
    {
        NSNumber *num = [self.tempIntakeDict objectForKey:NDB_No];
        if ([num intValue]>0)
        {
            needSaveData = YES;
            NSNumber *takenAmountNum = [intakeDict objectForKey:NDB_No];
            if (takenAmountNum)
                [intakeDict setObject:[NSNumber numberWithInt:[num intValue]+[takenAmountNum intValue]] forKey:NDB_No];
            else
                [intakeDict setObject:num forKey:NDB_No];
        }
    }
    if (needSaveData) {
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodChangedKey object:nil userInfo:nil];
        [[NSUserDefaults standardUserDefaults]setObject:intakeDict forKey:LZUserDailyIntakeKey];
        [[NSUserDefaults  standardUserDefaults]synchronize];
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (void)textFieldDidReturnForIndex:(NSIndexPath*)index andText:(NSString*)foodNumber
{
    //[self.foodIntakeAmountArray replaceObjectAtIndex:index.row withObject:foodNumber];
    self.currentFoodInputTextField = nil;
    NSDictionary *afood = [self.foodArray objectAtIndex:index.row];
    NSString *NDB_No = [afood objectForKey:@"NDB_No"];
    [self.tempIntakeDict setObject:[NSNumber numberWithInt:[foodNumber intValue]] forKey:NDB_No];
    NSLog(@"cell section %d , row %d food amount %@",index.section,index.row,foodNumber);
}
- (void)keyboardWillShow:(NSNotification *)notification {
	
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *boundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [boundsValue CGRectValue];
    
    CGFloat keyboardTop = self.view.frame.size.height - keyboardRect.size.height;
    CGRect tableviewFrame = self.listView.frame;
	tableviewFrame.size.height = keyboardTop-TopNavigationBarHeight;
    
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
	tableviewFrame.size.height = self.view.frame.size.height-TopNavigationBarHeight;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];
    
}
- (void)textFieldDidBeginEditingForIndex:(NSIndexPath*)index textField:(UITextField *)currentTextField
{
    self.currentFoodInputTextField = currentTextField;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.listView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    });
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

- (void)viewDidUnload {
    [self setListView:nil];
    [self setNavItem:nil];
    [super viewDidUnload];
}
@end
