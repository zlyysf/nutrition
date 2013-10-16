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
#import "MobClick.h"
#import "LZRecommendFood.h"
#import "LZFoodDetailController.h"
#import "JWNavigationViewController.h"
#import "LZDietListMakeViewController.h"
@interface LZDailyIntakeViewController ()<LZFoodDetailViewControllerDelegate>

@end

@implementation LZDailyIntakeViewController
@synthesize foodArray,titleString,isFromOut;
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
    if (ViewControllerUseBackImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    }

    self.title = titleString;
//    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setTitle:@"  添加" forState:UIControlStateNormal];
//    
//    button.frame = CGRectMake(0, 0, 48, 30);
//    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
//    [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = customBarItem;

    //self.navItem.leftBarButtonItem= customBarItem;
    //[self.admobView setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
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
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [MobClick beginLogPageView:UmengPathShiWuZhongLeiErJi];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathShiWuZhongLeiErJi];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [self setAdmobView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)backButtonTapped:(id)sender
//{
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
    
    //[self.navigationController popViewControllerAnimated:YES];
//}

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
	tableviewFrame.size.height = self.view.frame.size.height-CGSizeFromGADAdSize(kGADAdSizeBanner).height;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];
    
}

#pragma mark- TableViewDelegate
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
        //一个记录名称的数组 一个记录对应摄入量的数组
        NSDictionary *aFood = [self.foodArray  objectAtIndex:indexPath.row];
        //NSLog(@"picture path food list %@",aFood);
        NSString *picturePath;
        NSString *picPath = [aFood objectForKey:@"PicPath"];
        if (picPath == nil || [picPath isEqualToString:@""])
        {
            picturePath = [[NSBundle mainBundle]pathForResource:@"defaulFoodPic" ofType:@"png"];
        }
        else
        {
            NSString * picFolderPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"foodDealed"];
            picturePath = [picFolderPath stringByAppendingPathComponent:picPath];
        }
        UIImage *foodImage = [UIImage imageWithContentsOfFile:picturePath];
        [cell.foodPicView setImage:foodImage];
        cell.foodAmountLabel.hidden = YES;
        NSString *foodQueryKey;
        if ([LZUtility isCurrentLanguageChinese])
        {
            foodQueryKey = @"CnCaption";
        }
        else
        {
            foodQueryKey = @"FoodNameEn";
        }
        cell.foodNameLabel.text = [aFood objectForKey:foodQueryKey];
        //NSString *NDB_No = [aFood objectForKey:@"NDB_No"];
        //NSNumber *intake = [self.foodIntakeDictionary objectForKey:NDB_No];
//        UIImage *textImage = [UIImage imageNamed:@"setting_text_back.png"];
//        UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        //int num = [intake intValue];
//        if(num == 0)
//        {
//            cell.foodAmountLabel.text = @"0g";
//        }
//        else
//        {
            //cell.foodAmountLabel.text = [NSString stringWithFormat:@"%dg",num];
//        }
//        NSString *singleUnitName = [aFood objectForKey:COLUMN_NAME_SingleItemUnitName];
//        if ([singleUnitName length]==0)
//        {
//            cell.foodTotalUnitLabel.text = @"";
//        }
//        else
//        {
//            NSNumber *singleUnitWeight = [aFood objectForKey:COLUMN_NAME_SingleItemUnitWeight];
//            int unitCount = (int)((float)([intake floatValue]/[singleUnitWeight floatValue])+0.5);
//            if (unitCount <= 0)
//            {
//                cell.foodTotalUnitLabel.text = @"";
//            }
//            else
//            {
//                cell.foodTotalUnitLabel.text = [NSString stringWithFormat:@"(%d%@)",unitCount,singleUnitName];
//            }
//        }

        [cell.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *foodId  = [takenFoodIdsArray objectAtIndex:indexPath.row];
    [self.listView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *foodAtr = [self.foodArray  objectAtIndex:indexPath.row];//[takenFoodIdsArray objectAtIndex:indexPath.row];
    //NSString *NDB_No = [foodAtr objectForKey:@"NDB_No"];
    //NSDictionary * foodAttr = [allFoodUnitDict objectForKey:ndb_No];
    //NSArray *nutrientSupplyArr = [[takenFoodNutrientInfoDict objectForKey:Key_foodSupplyNutrientInfoAryDict]objectForKey:ndb_No];
    //NSArray *nutrientStandardArr = [[takenFoodNutrientInfoDict objectForKey:Key_foodStandardNutrientInfoAryDict]objectForKey:ndb_No];
    NSString *foodQueryKey;
    if ([LZUtility isCurrentLanguageChinese])
    {
        foodQueryKey = @"CnCaption";
    }
    else
    {
        foodQueryKey = @"FoodNameEn";
    }
    NSString *foodName = [foodAtr objectForKey:foodQueryKey];
    NSNumber *weight = [NSNumber numberWithInt:100];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodDetailController"];
    //            NSString *sectionTitle = [NSString stringWithFormat:@"%dg%@",[weight intValue],foodName];
    NSString *singleUnitName = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitName];
    NSNumber *upper = [NSNumber numberWithInt:1000];// [foodAtr objectForKey:COLUMN_NAME_Upper_Limit];
//    if ([weight intValue]>= [upper intValue])
//    {
//        upper = weight;
//    }
    foodDetailController.gUnitMaxValue = upper;
    
    if ([singleUnitName length]==0)
    {
        foodDetailController.isUnitDisplayAvailable = NO;
    }
    else
    {
        foodDetailController.isUnitDisplayAvailable = YES;
        foodDetailController.unitName = singleUnitName;
        NSNumber *singleUnitWeight = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
//        if ([LZUtility isUseUnitDisplay:weight unitWeight:singleUnitWeight])
//        {
//            foodDetailController.isDefaultUnitDisplay = YES;
//        }
//        else
//        {
//            foodDetailController.isDefaultUnitDisplay = NO;
//        }
        foodDetailController.isDefaultUnitDisplay = NO;
        int maxCount = (int)(ceilf(([upper floatValue]*2)/[singleUnitWeight floatValue]));
        foodDetailController.unitMaxValue = [NSNumber numberWithInt:maxCount];
//        if (maxCount <20)
//        {
//            foodDetailController.unitMaxValue = [NSNumber numberWithInt:20];
//        }
//        else
//        {
//            foodDetailController.unitMaxValue = [NSNumber numberWithInt:maxCount];
//        }
    }
    foodDetailController.isPushToDietPicker = isFromOut;
    foodDetailController.currentSelectValue = weight;
    foodDetailController.defaulSelectValue = weight;
    foodDetailController.foodAttr = foodAtr;
    foodDetailController.foodName = foodName;
    foodDetailController.delegate = self;
    foodDetailController.isCalForAll = NO;
    foodDetailController.GUnitStartIndex = 100;
    //UINavigationController *initialController = (UINavigationController*)[UIApplication
    //sharedApplication].keyWindow.rootViewController;
    JWNavigationViewController *nav = [[JWNavigationViewController alloc]initWithRootViewController:foodDetailController];
    [self presentModalViewController:nav animated:YES];

    
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
//#pragma mark- LZFoodCellDelegate
//- (void)foodButtonTappedForIndex:(NSIndexPath *)index
//{
//    if(self.currentFoodInputTextField != nil)
//    {
//        [self.currentFoodInputTextField resignFirstResponder];
//    }
//    NSDictionary *aFood = [self.foodArray objectAtIndex:index.row];
//    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSArray *standardArray = [rf formatFoodStandardContentForFood:aFood];
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    LZFoodInfoViewController *foodInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodInfoViewController"];
//    foodInfoViewController.nutrientStandardArray = standardArray;
//    foodInfoViewController.title = [aFood objectForKey:@"CnCaption"];
//    [self.navigationController pushViewController:foodInfoViewController animated:YES];
//}

//- (void)textFieldDidReturnForIndex:(NSIndexPath*)index andText:(NSString*)foodNumber
//{
//    //[self.foodIntakeAmountArray replaceObjectAtIndex:index.row withObject:foodNumber];
//    self.currentFoodInputTextField = nil;
//    if ([foodNumber intValue]>=0)
//    {
//        NSDictionary *afood = [self.foodArray objectAtIndex:index.row];
//        NSString *NDB_No = [afood objectForKey:@"NDB_No"];
//        [self.foodIntakeDictionary setObject:[NSNumber numberWithInt:[foodNumber intValue]] forKey:NDB_No];
//        //NSLog(@"cell section %d , row %d food amount %@",index.section,index.row,foodNumber);
//    }
//    NSMutableDictionary *intakeDict = [[NSMutableDictionary alloc]init];
//    BOOL needSaveData = NO;
//    for (NSString * NDB_No in [self.foodIntakeDictionary allKeys])
//    {
//        NSNumber *num = [self.foodIntakeDictionary objectForKey:NDB_No];
//        if ([num intValue]>=0)
//        {
//            needSaveData = YES;
//            if  ([num intValue]>0)
//            {
//                [intakeDict setObject:num forKey:NDB_No];
//            }
//        }
//    }
//    if (needSaveData) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodChangedKey object:nil userInfo:nil];
//        [[NSUserDefaults standardUserDefaults]setObject:intakeDict forKey:LZUserDailyIntakeKey];
//        [[NSUserDefaults  standardUserDefaults]synchronize];
//    }
//    
//    
//}
//- (void)textFieldDidBeginEditingForIndex:(NSIndexPath*)index textField:(UITextField *)currentTextField
//{
//    self.currentFoodInputTextField = currentTextField;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.listView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    });
//}
#pragma mark- LZFoodDetailViewControllerDelegate
-(void)didChangeFoodId:(NSString *)foodId toAmount:(NSNumber*)changedValue
{
//    if ([changedValue intValue]>=0)
//    {
//        [self.foodIntakeDictionary setObject:changedValue forKey:foodId];
//        //NSLog(@"cell section %d , row %d food amount %@",index.section,index.row,foodNumber);
//    }
//    NSMutableDictionary *intakeDict = [[NSMutableDictionary alloc]init];
//    BOOL needSaveData = NO;
//    for (NSString * NDB_No in [self.foodIntakeDictionary allKeys])
//    {
//        NSNumber *num = [self.foodIntakeDictionary objectForKey:NDB_No];
//        if ([num intValue]>=0)
//        {
//            needSaveData = YES;
//            if  ([num intValue]>0)
//            {
//                [intakeDict setObject:num forKey:NDB_No];
//            }
//        }
//    }
//    if (needSaveData) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodChangedKey object:nil userInfo:nil];
//        [[NSUserDefaults standardUserDefaults]setObject:intakeDict forKey:LZUserDailyIntakeKey];
//        [[NSUserDefaults  standardUserDefaults]synchronize];
//    }
    [LZUtility addFood:foodId withFoodAmount:changedValue];
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isMemberOfClass:[LZDietListMakeViewController class]])
        {
           [self.navigationController popToViewController:vc animated:NO];
            break;
    
        }
    }
    //[self.listView reloadData];
}

@end
