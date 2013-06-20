//
//  LZDailyIntakeViewController.m
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDailyIntakeViewController.h"
#import "LZFoodCell.h"
#import "LZConstants.h"
#import "GADMasterViewController.h"
@interface LZDailyIntakeViewController ()<LZFoodCellDelegate>

@end

@implementation LZDailyIntakeViewController
@synthesize foodIntakeDictionary,foodArray,currentFoodInputTextField,titleString;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    self.navItem.title = titleString;
    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"  返回" forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 48, 30);
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navItem.leftBarButtonItem= customBarItem;
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
//                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).width,
//                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
//    self.listView.tableFooterView = footerView;
 	// Do any additional setup after loading the view.
    //获取食物名称 初始化foodNameArray 和 foodIntakeAmountArray
//    allFood = [[LZDataAccess singleton]getAllFood];
//    NSMutableSet *foodTypeSet = [NSMutableSet set];
//    self.foodTypeArray = [[NSMutableArray alloc]init];
//    self.foodNameArray = [[NSMutableArray alloc]init];
//    NSDictionary *dailyIntake = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
//
//    self.foodIntakeDictionary = [[NSMutableDictionary alloc]init];
//    for (int i = 0; i< [allFood count]; i++)
//    {
//        NSDictionary *afood = [allFood objectAtIndex:i];
//        NSString *foodType = [afood objectForKey:@"CnType"];
//        NSString *NDB_No = [afood objectForKey:@"NDB_No"];
//        if (dailyIntake != nil)
//        {
//            NSNumber *intakeNumber = [dailyIntake objectForKey:NDB_No];
//            if (intakeNumber)
//            {
//                [self.foodIntakeDictionary setObject:intakeNumber forKey:NDB_No];
//            }
//            else
//            {
//                [self.foodIntakeDictionary setObject:[NSNumber numberWithInt:0] forKey:NDB_No];
//            }
//        }
//        else
//        {
//            [self.foodIntakeDictionary setObject:[NSNumber numberWithInt:0] forKey:NDB_No];
//        }
//        if (![foodTypeSet containsObject:foodType])
//        {
//            NSMutableArray *foodName = [[NSMutableArray alloc]init];
//            [foodName addObject:afood];
//            [self.foodNameArray addObject:foodName];
//            [self.foodTypeArray addObject:foodType];
//            [foodTypeSet addObject:foodType];
//        }
//        else
//        {
//           int index = [self.foodTypeArray indexOfObject:foodType];
//            [[self.foodNameArray objectAtIndex:index]addObject:afood];
//        }
//    }
//    NSLog(@"footypearray %@, foodtypeset %@",self.foodTypeArray,foodTypeSet);
//
//    NSLog(@"foodnamearray %@",self.foodNameArray);
//    self.selectorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"selector_back.png"]];
//    self.selectorView.dataSource = self;
//    self.selectorView.delegate = self;
//    self.selectorView.shouldBeTransparent = YES;
//    self.selectorView.horizontalScrolling = YES;
//    self.selectorView.debugEnabled = NO;
//    self.currentSelectedIndex = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.foodArray count];
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//
//    return 1;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        LZFoodCell* cell =(LZFoodCell*)[tableView dequeueReusableCellWithIdentifier:@"FoodCell"];
        cell.delegate = self;
        cell.cellIndexPath = indexPath;
        //一个记录名称的数组 一个记录对应摄入量的数组
        NSDictionary *aFood = [self.foodArray  objectAtIndex:indexPath.row];
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
        NSNumber *intake = [self.foodIntakeDictionary objectForKey:NDB_No];
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
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView == foodSearchDisplayController.searchResultsTableView)
//    {
//        NSDictionary *aFood = [self.searchResultArray objectAtIndex:indexPath.row];
//        NSString *aFoodType = [aFood objectForKey:@"CnType"];
//        NSString *aFoodNo = [aFood objectForKey:@"NDB_No"];
//        int section= -1;
//        int row= -1;
//        NSLog(@"%@",aFood);
//        for (NSString *type in self.foodTypeArray)
//        {
//            if([type isEqualToString:aFoodType])
//            {
//                section = [self.foodTypeArray indexOfObject:type];
//                break;
//            }
//
//        }
//
//        if (section >=0 && section<[self.foodNameArray count]) {
//            NSArray *subArray = [self.foodNameArray objectAtIndex:section];
//            for (NSDictionary *dict in subArray)
//            {
//                if ([[dict objectForKey:@"NDB_No"]isEqualToString:aFoodNo])
//                {
//                    row = [subArray indexOfObject:dict];
//                    break;
//                }
//            }
//        }
//        if (section >= 0 && row >= 0)
//        {
//            [foodSearchBar resignFirstResponder];
//            [foodSearchDisplayController setActive:NO animated:NO];
//            NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:section];
//            NSLog(@"%@",[index description]);
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self.listView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//                LZFoodCell *cell = (LZFoodCell*)[self.listView cellForRowAtIndexPath:index];
//                [cell.intakeAmountTextField becomeFirstResponder];
//            });
//            
//        }
//    }
//}
//#pragma IZValueSelector dataSource
//- (NSInteger)numberOfRowsInSelector:(LZValueSelectorView *)valueSelector {
//    return [self.foodTypeArray count];
//}
//
//
//
////ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
//- (CGFloat)rowHeightInSelector:(LZValueSelectorView *)valueSelector {
//    return 320/3;
//}
//
//- (CGFloat)rowWidthInSelector:(LZValueSelectorView *)valueSelector {
//    return 320/3;
//}
//
//
//- (UIView *)selector:(LZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index {
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320/3 , 41)];
//    [label setFont:[UIFont systemFontOfSize:18.f]];
//    label.textColor = [UIColor whiteColor];
//    label.text = [self.foodTypeArray objectAtIndex:index];
//    label.textAlignment =  NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor clearColor];
//    return label;
//}
//
//- (CGRect)rectForSelectionInSelector:(LZValueSelectorView *)valueSelector {
//    //Just return a rect in which you want the selector image to appear
//    //Use the IZValueSelector coordinates
//    //Basically the x will be 0
//    //y will be the origin of your image
//    //width and height will be the same as in your selector image
////    if (valueSelector == self.selectorHorizontal) {
////        return CGRectMake(self.selectorHorizontal.frame.size.width/2 - 35.0, 0.0, 70.0, 90.0);
////    }
////    else {
////        return CGRectMake(0.0, self.selectorVertical.frame.size.height/2 - 35.0, 90.0, 70.0);
////    }
//    return CGRectMake(320/3,0,320/3,41);
//}
//
//#pragma IZValueSelector delegate
//- (void)selector:(LZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
//    NSLog(@"Selected index %d",index);
//    if(self.currentFoodInputTextField != nil)
//    {
//        [self.currentFoodInputTextField resignFirstResponder];
//    }
//    currentSelectedIndex = index;
//    [self.listView reloadData];
//}
- (IBAction)backButtonTapped:(id)sender
{
    if(self.currentFoodInputTextField != nil)
    {
        [self.currentFoodInputTextField resignFirstResponder];
    }
//    NSMutableDictionary *intakeDict = [[NSMutableDictionary alloc]init];
//    BOOL needSaveData = NO;
//    for (NSString * NDB_No in [self.foodIntakeDictionary allKeys])
//    {
//        NSNumber *num = [self.foodIntakeDictionary objectForKey:NDB_No];
//        if ([num intValue]>0)
//        {
//            needSaveData = YES;
//            [intakeDict setObject:num forKey:NDB_No];
//        }
//    }
//    if (needSaveData) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodChangedKey object:nil userInfo:nil];
//        [[NSUserDefaults standardUserDefaults]setObject:intakeDict forKey:LZUserDailyIntakeKey];
//        [[NSUserDefaults  standardUserDefaults]synchronize];
//    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidReturnForIndex:(NSIndexPath*)index andText:(NSString*)foodNumber
{
    //[self.foodIntakeAmountArray replaceObjectAtIndex:index.row withObject:foodNumber];
    self.currentFoodInputTextField = nil;
    if ([foodNumber intValue]>=0)
    {
        NSDictionary *afood = [self.foodArray objectAtIndex:index.row];
        NSString *NDB_No = [afood objectForKey:@"NDB_No"];
        [self.foodIntakeDictionary setObject:[NSNumber numberWithInt:[foodNumber intValue]] forKey:NDB_No];
        NSLog(@"cell section %d , row %d food amount %@",index.section,index.row,foodNumber);
    }
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
	tableviewFrame.size.height = self.view.frame.size.height-TopNavigationBarHeight-CGSizeFromGADAdSize(kGADAdSizeBanner).height;
    
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
- (void)textFieldDidBeginEditingForIndex:(NSIndexPath*)index textField:(UITextField *)currentTextField
{
    self.currentFoodInputTextField = currentTextField;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.listView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    });
}
//#pragma mark -
//#pragma mark UISearchDisplayController Delegate Methods
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
//    [self.searchResultArray removeAllObjects];
//    // Return YES to cause the search result table view to be reloaded.
//    NSLog(@"%@",searchString);
//    for (int i=0; i<[allFood count]; i++)
//    {
//        NSDictionary *aFood = [allFood objectAtIndex:i];
//        NSString *cnName = [aFood objectForKey:@"CnCaption"];
//        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchString];
//        if ([pre evaluateWithObject:cnName])
//        {
//            [self.searchResultArray addObject:aFood];
//        }
//        
//    }
//    
//   //NSArray *arrayPre=[allFood filteredArrayUsingPredicate: pre];
//    //NSLog(@"result %@",arrayPre);
//    return YES;
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}
//
//- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
//	/*
//     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
//     */
//	[foodSearchDisplayController.searchResultsTableView setDelegate:self];
//    
//}
//
//- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
//	
//    [foodSearchBar resignFirstResponder];
//}
- (void)viewDidUnload
{
    [self setNavItem:nil];
    [self setAdmobView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
