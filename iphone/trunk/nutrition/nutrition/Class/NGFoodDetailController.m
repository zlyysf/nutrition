//
//  NGFoodDetailController.m
//  目前还有bug未能解决，在ios6上刻度数字能正常显示，但在ios7上就不行了
//
//  Created by zly on 2/10/14.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGFoodDetailController.h"
#import "LZConstants.h"
#import "NGNutritionSupplyCell.h"
#import "LZUtility.h"
#import "GADMasterViewController.h"
#import "MobClick.h"
//#import "LZDietPickerViewController.h"
#import "LZNutrientionManager.h"
#import "LZGlobal.h"
#import "LZGlobalService.h"


#define LongLineHeight 20.f
#define ShortLineHeight 10.f
#define ValuePickerHeight 50.f
#define GUnitWidth 8.f //20.f can show kedushuzhi//8.f
#define UnitWidth 40.f
#define ValuePickerLabelFontSize 12.f
#define SingleLineWitdh 1.f
#define ValuePickerLabelWidth 36.f
#define UnitStartIndex 0
@interface NGFoodDetailController ()
{
//    BOOL isFirstLoad;
    BOOL isChinese;
}

@end

@implementation NGFoodDetailController{
    NSString *foodNameLocal;
    NSMutableDictionary *inOutParam;
    NSArray *nutrientSupplyArray;
}

@synthesize FoodId,FoodAttr,FoodAmount,
    BackToViewControllerWhenFinish,
    editDelegate,
//    delegate,
    isForEdit,isCalForAll, notNeedSave, staticFoodAmountDict;

//@synthesize nutrientSupplyArray,UseUnitDisplay,sectionLabel,isUnitDisplayAvailable,gUnitMaxValue,unitMaxValue,,isDefaultUnitDisplay,inOutParam,defaulSelectValue,,unitName,GUnitStartIndex,isPushToDietPicker;


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
    [LZGlobalService SetSubViewExternNone:self];//从膳食清单的任何页面进到这个页面不需要这条语句，但是在百科上的任何页面进到这个页面就需要
    
//    if (ViewControllerUseBackImage) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
//        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
//        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
//    }
    
    isChinese = [LZUtility isCurrentLanguageChinese];
    
    foodNameLocal = [LZUtility getLocalFoodName:FoodAttr];
    self.title = foodNameLocal;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"quxiaobutton", @"取消") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    if (notNeedSave){
        //not add save button
    }else{
        NSString *rightTitle;
        if (isForEdit) {
            rightTitle = NSLocalizedString(@"quedingbutton", @"确定");
        }else{
            rightTitle = NSLocalizedString(@"tianjiabutton", @"添加");
        }
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:rightTitle style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
        self.navigationItem.rightBarButtonItem = saveItem;
    }

    if (!needFee){
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                                     CGSizeFromGADAdSize(kGADAdSizeBanner).width, CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
        self.listView.tableFooterView = footerView;
    }
    

//    isFirstLoad = YES;
    self.listView.hidden = YES;
    [self.GUnitButton setTitle:NSLocalizedString(@"weightunit_g", @"克") forState:UIControlStateNormal];
    
    self.LabelWeightUnit.text = NSLocalizedString(@"weightunit_g", @"克");
    self.GUnitButton.hidden = true;
    self.UnitButton.hidden = true;
    self.foodAmountDisplayLabel.textAlignment = NSTextAlignmentRight;
    
    
    [self.RuleSlider scrollToGivenMark:[FoodAmount intValue]];
}
-(void)displayNutrientUI
{
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    if (isCalForAll)
    {
        if(inOutParam == nil)
        {
            NSDictionary *userInfo = [LZUtility getUserInfo];
            NSDictionary * allFoodAttr2LevelDict = [[LZGlobal SharedInstance] getAllFood2LevelDict];
            
            inOutParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           userInfo,Key_userInfo,
                                           FoodAttr,@"dynamicFoodAttrs",
                                           FoodAmount,@"dynamicFoodAmount",
                                           allFoodAttr2LevelDict,@"staticFoodAttrsDict2Level",
                                           nil];
            if (staticFoodAmountDict!=nil){
                inOutParam[@"staticFoodAmountDict"] = staticFoodAmountDict;
            }
        }
        else
        {
            [inOutParam setObject:FoodAmount forKey:@"dynamicFoodAmount"];
        }
        nutrientSupplyArray = [rf calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI:inOutParam];
    }
    else
    {
        if(inOutParam == nil)
        {
            NSDictionary *userInfo = [LZUtility getUserInfo];
            inOutParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     userInfo,Key_userInfo,
                                                     FoodAttr,@"FoodAttrs",
                                                     FoodAmount,@"FoodAmount",
                                                     nil];
        }
        else
        {
            [inOutParam setObject:FoodAmount forKey:@"FoodAmount"];
        }
        nutrientSupplyArray = [rf calculateGiveFoodSupplyNutrientAndFormatForUI:inOutParam];
    }
    
    self.listView.hidden = NO;
    [self.listView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (isCalForAll) {
        self.sectionLabel.text = NSLocalizedString(@"fooddetail_tablesection_title1", @"所有食物的一天营养比例");
    }
    else{
        self.sectionLabel.text = NSLocalizedString(@"fooddetail_tablesection_title2",@"当前食物的一天营养比例");
    }

    [MobClick beginLogPageView:UmengPathShiWuXiangQing];
    
    if (!needFee){
        GADMasterViewController *shared = [GADMasterViewController singleton];
        UIView *footerView = self.listView.tableFooterView;
        [shared resetAdView:self andListView:footerView];
    }
    
//    [self setButtonState];

}
- (void)viewDidAppear:(BOOL)animated
{
//    if (isFirstLoad)
//    {
//        [self firstDisplay];
//    }
}
//- (void)firstDisplay
//{
//    if (isFirstLoad)
//    {
//        isFirstLoad = NO;
//        int index = 0;
//        int weight = [defaulSelectValue intValue];
//        if (isUnitDisplayAvailable)
//        {
//            if(isDefaultUnitDisplay)
//            {
//                if(weight<= 0)
//                {
//                    index = UnitStartIndex;
//                }
//                else
//                {
//                    NSNumber *singleUnitWeight = [self.foodAttr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
//                    index = ([defaulSelectValue intValue]*2)/[singleUnitWeight intValue] ;
//                }
//            }
//            else
//            {
//                index = (weight<=0?GUnitStartIndex:weight);
//            }
//        }
//        else
//        {
//            index = (weight<=0?GUnitStartIndex:weight);
//        }
////        [self.foodValuePicker setSelectedIndex:index];
//        [self.RuleSlider scrollToGivenMark:index];
//    }
//}
-(void)cancelButtonTapped
{
//    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveButtonTapped
{
    // if self.delegate
//    if (isPushToDietPicker)
//    {
////        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
////        LZDietPickerViewController *dietPickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietPickerViewController"];
////        NSDictionary *foodDict = [[NSDictionary alloc]initWithObjectsAndKeys:currentSelectValue,[self.foodAttr objectForKey:@"NDB_No"], nil];
////        dietPickerViewController.foodDict = foodDict;
////        [self.navigationController pushViewController:dietPickerViewController animated:YES];
//    }
//    else
//    {
//        if(self.delegate && [self.delegate respondsToSelector:@selector(didChangeFoodId:toAmount:)])
//        {
//            [self.delegate didChangeFoodId:FoodId toAmount:FoodAmount];
//        }
////        [self.navigationController dismissModalViewControllerAnimated:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
    //TODO 这里可以用 isForEdit 来判断决定具体 是加还是改......这样就会省掉 NGSelectFoodAmountDelegate 而只用 NGFoodCombinationEditViewControllerDelegate
//    if(self.delegate && [self.delegate respondsToSelector:@selector(didChangeFoodId:toAmount:)])
//    {
//        [self.delegate didChangeFoodId:FoodId toAmount:FoodAmount];
//    }
    if (isForEdit){
        if (self.editDelegate && [self.editDelegate respondsToSelector:@selector(changeToCombinationWithFoodId:andAmount:)]){
            [self.editDelegate changeToCombinationWithFoodId:FoodId andAmount:FoodAmount];
        }
    }else{
        if (self.editDelegate && [self.editDelegate respondsToSelector:@selector(addToCombinationWithFoodId:andAmount:)]){
            [self.editDelegate addToCombinationWithFoodId:FoodId andAmount:FoodAmount];
        }
    }
    [self.navigationController popToViewController:(UIViewController*)BackToViewControllerWhenFinish animated:YES];

    
    return;
}
//-(void)setButtonState
//{
//    if (!isUnitDisplayAvailable)
//    {
//        self.UnitButton.hidden = YES;
//        //self.GUnitButton.hidden = YES;
//    }
//    else
//    {
//        self.UnitButton.hidden = NO;
//        [self.UnitButton setTitle:unitName forState:UIControlStateNormal];
//        //self.GUnitButton.hidden = NO;
//    }
//    if (!UseUnitDisplay)
//    {
//        [self.UnitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.UnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_normal.png"] forState:UIControlStateNormal];
//        [self.GUnitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.GUnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_clicked.png"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.UnitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.UnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_clicked.png"] forState:UIControlStateNormal];
//        [self.GUnitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.GUnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_normal.png"] forState:UIControlStateNormal];
//    }
//    [self.UnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_clicked.png"] forState:UIControlStateHighlighted];
//    [self.GUnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_clicked.png"] forState:UIControlStateHighlighted];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathShiWuXiangQing];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0)
//    {
        if (nutrientSupplyArray != nil && [nutrientSupplyArray count]!=0)
        {
            return [nutrientSupplyArray count];
        }
        else
            return 0;
//    }
//    else
//    {
//        if (nutrientStandardArray != nil && [nutrientStandardArray count]!=0)
//        {
//            return [nutrientStandardArray count];
//        }
//        else
//            return 0;
//    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//        NGNutritionSupplyCell *cell = (NGNutritionSupplyCell *)[tableView dequeueReusableCellWithIdentifier:@"NGNutritionSupplyCell"];
//        NSDictionary *nutrientSupplyInfo = [nutrientSupplyArray objectAtIndex:indexPath.row];
//        NSString *nutrientId = [nutrientSupplyInfo objectForKey:@"NutrientID"];
//    
//        NSDictionary * AllNutrient2LevelDict = [[LZGlobal SharedInstance] getAllNutrient2LevelDict];
//        NSDictionary *nutrientDict = [AllNutrient2LevelDict objectForKey:nutrientId];
//        NSString *nutritionName = [LZUtility getLocalNutrientName:nutrientDict];
//    
//        cell.nutrientId = nutrientId;
//        [cell.nameButton setTitle:nutritionName forState:UIControlStateNormal];
//        NSNumber *percent = [nutrientSupplyInfo objectForKey:@"1foodSupply1NutrientRate"];
//        NSNumber *food1Supply1NutrientAmount = [nutrientSupplyInfo objectForKey:@"food1Supply1NutrientAmount"];
//        NSNumber *nutrientTotalDRI = [nutrientSupplyInfo objectForKey:@"nutrientTotalDRI"];
//        NSString *unit = [nutrientSupplyInfo objectForKey:@"Unit"];
//        float progress = [percent floatValue]>1.f ? 1.f :[percent floatValue];
//        float radius;
//        if (progress >0.03 ) {
//            radius = 4;
//        } else {
//            radius = 2;
//        }
//        UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:nutrientId];
//        [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:7.f fillRadius:radius];
//        cell.nutrientSupplyLabel.text = [NSString stringWithFormat:@"%d%% (%.2f/%.2f%@)",(int)([percent floatValue] *100),[food1Supply1NutrientAmount floatValue],[nutrientTotalDRI floatValue ],unit];
//        return cell;
    
    
    NGNutritionSupplyCell *cell = (NGNutritionSupplyCell *)[tableView dequeueReusableCellWithIdentifier:@"NGNutritionSupplyCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *nutrientSupplyInfo = [nutrientSupplyArray objectAtIndex:indexPath.row];
    NSString *nutrientId = [nutrientSupplyInfo objectForKey:@"NutrientID"];
    
    NSDictionary * AllNutrient2LevelDict = [[LZGlobal SharedInstance] getAllNutrient2LevelDict];
    NSDictionary *nutrientDict = [AllNutrient2LevelDict objectForKey:nutrientId];
    NSString *nutritionNameShort = [LZUtility getLocalNutrientShortName:nutrientDict];
    
    cell.nutrientId = nutrientId;
    
    [cell.nutritionNameLabel setText:nutritionNameShort];

    NSNumber *percent = [nutrientSupplyInfo objectForKey:@"1foodSupply1NutrientRate"];
    NSNumber *food1Supply1NutrientAmount = [nutrientSupplyInfo objectForKey:@"food1Supply1NutrientAmount"];
    NSNumber *nutrientTotalDRI = [nutrientSupplyInfo objectForKey:@"nutrientTotalDRI"];
    NSString *unit = [nutrientSupplyInfo objectForKey:@"Unit"];
    float progress = [percent floatValue]>1.f ? 1.f :[percent floatValue];

    UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:nutrientId];
    
    [cell.nutritionProgressView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.nutritionProgressView.layer setBorderWidth:0.5f];
    [cell.nutritionProgressView drawProgress_with_backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:0.f fillRadius:0.f];
    
    cell.nutrientSupplyLabel.text = [NSString stringWithFormat:@"%d%% (%.2f/%.2f%@)",(int)([percent floatValue] *100),[food1Supply1NutrientAmount floatValue],[nutrientTotalDRI floatValue ],unit];
    
    
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        return 42;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //if( section == 0)
        return 5;
//    else
//        return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //float height = (section == 0 ?5:20);
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}// Default is 1 if not implemented
- (IBAction)gUnitButtonTapped:(UIButton *)sender
{
//    if (!UseUnitDisplay)
//    {
//        return;
//    }
//    UseUnitDisplay = NO;
//    [self setButtonState];
//    [self.foodValuePicker reloadData];
//    int index = 0;
//    if (isDefaultUnitDisplay)
//    {
//        index = GUnitStartIndex;
//    }
//    else
//    {
//        index = [defaulSelectValue intValue];
//    }
//    [self.foodValuePicker setSelectedIndex:index];
}
- (IBAction)unitButtonTapped:(UIButton *)sender
{
//    if (UseUnitDisplay)
//    {
//        return;
//    }
//    UseUnitDisplay = YES;
//    [self setButtonState];
//    [self.foodValuePicker reloadData];
//    int index = 0;
//    if (isDefaultUnitDisplay)
//    {
//        NSNumber *singleUnitWeight = [self.foodAttr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
//        index = ([defaulSelectValue intValue]*2)/[singleUnitWeight intValue] ;
//        if (index <= 0)
//        {
//            index = UnitStartIndex;
//        }
//    }
//    else
//    {
//        index = UnitStartIndex;
//    }
//
//    [self.foodValuePicker setSelectedIndex:index];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setFoodAmountDisplayLabel:nil];
    [self setGUnitButton:nil];
    [self setUnitButton:nil];
    [super viewDidUnload];
}

-(void)refreshViewsWithFoodAmount:(int)amount
{
    FoodAmount = [NSNumber numberWithInt:amount];
    [self.foodAmountDisplayLabel setText:[NSString stringWithFormat:@"%d",amount]];
    [self displayNutrientUI];
}


#pragma mark- LZMySliderByScrollViewDelegate
- (void)scrollStopped:(int)curMark
{
    [self refreshViewsWithFoodAmount:curMark];
}

- (void)scrolling:(int)curMark
{
    [self refreshViewsWithFoodAmount:curMark];
}




@end
