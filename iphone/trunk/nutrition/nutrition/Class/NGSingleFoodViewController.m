//
//  NGSingleFoodViewController.m
//  nutrition
//
//  Created by liu miao on 12/9/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGSingleFoodViewController.h"
#import "LZRecommendFood.h"
#import "LZConstants.h"
#import "NGFoodNutritionCell.h"
#import "LZNutrientionManager.h"
@interface NGSingleFoodViewController ()
{
    BOOL isChinese;
    BOOL isFirstLoad;
    BOOL isUsingUnitDisplay;
}
@property (nonatomic, assign)int currentValue;
@property (nonatomic,assign)int unitPerValue;
@property (nonatomic,assign)int gMaxValue;
@property (nonatomic,assign)int unitMaxValue;


@end

@implementation NGSingleFoodViewController
@synthesize foodInfoDict,nutrientSupplyArray,inOutParam,currentValue,unitPerValue,gMaxValue,unitMaxValue;
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
    isChinese = [LZUtility isCurrentLanguageChinese];
    isFirstLoad = YES;
    [self.contentScrollView
 setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    [self.weightSelectView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.weightSelectView.layer setBorderWidth:0.5f];
    [self.topHeaderLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.topHeaderLabel.layer setBorderWidth:0.5f];
    [self.underHeaderLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.underHeaderLabel.layer setBorderWidth:0.5f];
    [self.nutritionListView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.nutritionListView.layer setBorderWidth:0.5f];
    [self.topHeaderLabel setBackgroundColor:[UIColor colorWithRed:236/255.f green:240/255.f blue:232/255.f alpha:1.0f]];
    [self.underHeaderLabel setBackgroundColor:[UIColor colorWithRed:236/255.f green:240/255.f blue:232/255.f alpha:1.0f]];
    [self.topHeaderLabel setText:[NSString stringWithFormat:@"  %@",NSLocalizedString(@"shiwu_xuanzezhonglian", @"选择重量")]];
    [self.underHeaderLabel setText:[NSString stringWithFormat:@"  %@",NSLocalizedString(@"shiwu_yingyanghanliang", @"营养含量")]];
    [self initialize];

    
	// Do any additional setup after loading the view.
}
-(void)initialize
{
    NSNumber *foodAmount = [foodInfoDict objectForKey:Key_FoodAmount];
    int amount =(int)(ceilf([foodAmount floatValue]));
    //int weightAmount = (int)(ceilf([weight floatValue]));
    // if (weightAmount <=0 )
    //{
    NSNumber *weight ;
    if (amount>0)
    {
        weight = [NSNumber numberWithInt:amount];
    }
    else
    {
        weight = [NSNumber numberWithInt:0];
    }
    //}
    
    
    NSString *singleUnitName = [LZUtility getSingleItemUnitName:[foodInfoDict objectForKey:COLUMN_NAME_SingleItemUnitName]];
    NSNumber *upper = [NSNumber numberWithInt:1000];// [foodAtr objectForKey:COLUMN_NAME_Upper_Limit];
    if ([weight intValue]>= [upper intValue])
    {
        upper = weight;
    }
    gMaxValue = [upper intValue];
    
    if ([singleUnitName length]==0)
    {
        //[self.unitSegmentControl setEnabled:NO forSegmentAtIndex:1];
        //[self.unitSegmentControl setTitle:@"" forSegmentAtIndex:1];
        [self.unitSegmentControl removeSegmentAtIndex:1 animated:NO];
    }
    else
    {
        [self.unitSegmentControl setEnabled:YES forSegmentAtIndex:1];
        [self.unitSegmentControl setTitle:singleUnitName forSegmentAtIndex:1];
        NSNumber *singleUnitWeight = [foodInfoDict objectForKey:COLUMN_NAME_SingleItemUnitWeight];
        //        if ([LZUtility isUseUnitDisplay:weight unitWeight:singleUnitWeight])
        //        {
        //            foodDetailController.isDefaultUnitDisplay = YES;
        //        }
        //        else
        //        {
        //            foodDetailController.isDefaultUnitDisplay = NO;
        //        }
        
        [self.unitSegmentControl setSelectedSegmentIndex:0];
        int maxCount = (int)(ceilf(([upper floatValue]*2)/[singleUnitWeight floatValue]));
        //        if (maxCount <20)
        //        {
        //            foodDetailController.unitMaxValue = [NSNumber numberWithInt:20];
        //        }
        //        else
        //        {
        //            foodDetailController.unitMaxValue = [NSNumber numberWithInt:maxCount];
        //        }
        unitMaxValue = maxCount;
        unitPerValue = [singleUnitWeight intValue];
    }
    isUsingUnitDisplay = NO;
    currentValue = 100;
    [self.weightChangeStepper setMinimumValue:0];
    [self.weightChangeStepper setMaximumValue:gMaxValue];
    [self.weightChangeStepper setValue:100];
    [self.weightChangeStepper setStepValue:20];
    self.weightDisplayLabel.text = [NSString stringWithFormat:@"%d",currentValue];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (isFirstLoad)
    {
        [self displayNutrientUI];
        isFirstLoad = NO;
    }
}
- (IBAction)stepperChanged:(UIStepper *)sender {
    NSLog(@"stepperChanged");
    if (isUsingUnitDisplay)
    {
        currentValue = sender.value *unitPerValue;
        //self.weightDisplayLabel.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    }
    else
    {
        currentValue = sender.value;
        //self.weightDisplayLabel.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    }
    if ((sender.value-(int)sender.value)<Config_nearZero)
    {
        self.weightDisplayLabel.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    }
    else
    {
        self.weightDisplayLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    }
    
    [self displayNutrientUI];
}
- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0)
    {
        isUsingUnitDisplay = NO;
        currentValue = 100;
        [self.weightChangeStepper setMinimumValue:0];
        [self.weightChangeStepper setMaximumValue:gMaxValue];
        [self.weightChangeStepper setValue:100];
        [self.weightChangeStepper setStepValue:20];
        self.weightDisplayLabel.text = [NSString stringWithFormat:@"%d",currentValue];
    }
    else
    {
        [self.weightChangeStepper setMinimumValue:0];
        [self.weightChangeStepper setMaximumValue:unitMaxValue];
        [self.weightChangeStepper setValue:1];
        [self.weightChangeStepper setStepValue:0.5];
        isUsingUnitDisplay = YES;
        currentValue = 1*unitPerValue;
        self.weightDisplayLabel.text = [NSString stringWithFormat:@"%d",1];
    }
    
    [self displayNutrientUI];
    NSLog(@"segmentChanged");
}

-(void)displayNutrientUI
{
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];

    if(self.inOutParam == nil)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSNumber *userSex = [userDefaults objectForKey:LZUserSexKey];
        NSNumber *userAge = [userDefaults objectForKey:LZUserAgeKey];
        NSNumber *userHeight = [userDefaults objectForKey:LZUserHeightKey];
        NSNumber *userWeight = [userDefaults objectForKey:LZUserWeightKey];
        NSNumber *userActivityLevel = [userDefaults objectForKey:LZUserActivityLevelKey];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  userSex,ParamKey_sex, userAge,ParamKey_age,
                                  userWeight,ParamKey_weight, userHeight,ParamKey_height,
                                  userActivityLevel,ParamKey_activityLevel, nil];
        inOutParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      userInfo,Key_userInfo,
                      self.foodInfoDict,@"FoodAttrs",
                      [NSNumber numberWithInt:currentValue],@"FoodAmount",
                      nil];
    }
    else
    {
        [inOutParam setObject:[NSNumber numberWithInt:currentValue] forKey:@"FoodAmount"];
    }
    self.nutrientSupplyArray = [rf calculateGiveFoodSupplyNutrientAndFormatForUI:self.inOutParam];
    if (isFirstLoad)
    {
        float tableViewHeight = [self.nutrientSupplyArray count]*55;
        [self.contentScrollView setContentSize:CGSizeMake(320, 184+tableViewHeight+20)];
        [self.nutritionListView setFrame:CGRectMake(10, 184, 300, tableViewHeight)];
    }
    [self.nutritionListView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 0)
    //    {
    NGFoodNutritionCell *cell = (NGFoodNutritionCell *)[tableView dequeueReusableCellWithIdentifier:@"NGFoodNutritionCell"];
    NSDictionary *aNutrient = [nutrientSupplyArray objectAtIndex:indexPath.row];
    NSString *nutrientId = [aNutrient objectForKey:@"NutrientID"];
    NSString *queryKey;
    if (isChinese)
    {
        queryKey = @"NutrientCnCaption";
    }
    else
    {
        queryKey = @"NutrientEnCaption";
    }
    LZNutrientionManager *nm = [LZNutrientionManager SharedInstance];
    NSDictionary *dict = [nm getNutritionInfo:nutrientId];
    NSString *nutritionName = [dict objectForKey:queryKey];
    
    UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:nutrientId];
    //cell.nutrientId = nutrientId;
    //[cell.nameButton setTitle:nutritionName forState:UIControlStateNormal];
    cell.nutritionNameLabel.text = nutritionName;
    NSNumber *percent = [aNutrient objectForKey:@"1foodSupply1NutrientRate"];
    //NSNumber *food1Supply1NutrientAmount = [aNutrient objectForKey:@"food1Supply1NutrientAmount"];
    NSNumber *nutrientTotalDRI = [aNutrient objectForKey:@"nutrientTotalDRI"];
    NSString *unit = [aNutrient objectForKey:@"Unit"];
    if ([nutrientTotalDRI floatValue ]>=100)
    {
        if ([unit isEqualToString:@"kcal"])
        {

        }
        else if ([unit isEqualToString:@"mg"])
        {
            unit = @"g";
            nutrientTotalDRI = [NSNumber numberWithFloat:[nutrientTotalDRI floatValue ]/1000];
        }
        else if ([unit isEqualToString:@"g"])
        {
            unit = @"kg";
            nutrientTotalDRI = [NSNumber numberWithFloat:[nutrientTotalDRI floatValue ]/1000];
        }
        else
        {
            unit = @"mg";
            nutrientTotalDRI = [NSNumber numberWithFloat:[nutrientTotalDRI floatValue ]/1000];
        }
    }
    float progress = [percent floatValue]>1.f ? 1.f :[percent floatValue];
    float radius;
    if (progress >0.03 )
    {
        radius = 4;
    }
    else
    {
        radius = 2;
    }
    [cell.supplyProgressView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.supplyProgressView.layer setBorderWidth:0.5f];
    [cell.supplyProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:0.f fillRadius:0.f];
    
    cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%/%.1f%@",(int)([percent floatValue] *100),[nutrientTotalDRI floatValue ],unit];
    return cell;
    //    }
    //    else
    //    {
    //        LZStandardContentCell *cell = (LZStandardContentCell *)[tableView dequeueReusableCellWithIdentifier:@"LZStandardContentCell"];
    //        NSDictionary *nutrientStandard = [nutrientStandardArray objectAtIndex:indexPath.row];
    //        NSString *nutrientName = [nutrientStandard objectForKey:@"Name"];
    //        NSNumber *foodNutrientContent = [nutrientStandard objectForKey:@"foodNutrientContent"];
    //        NSString *unit = [nutrientStandard objectForKey:@"Unit"];
    //        if (indexPath.row == 0)
    //        {
    //            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_top@2x" ofType:@"png"];
    //            UIImage * cellTopImage = [UIImage imageWithContentsOfFile:path];
    //
    //            [cell.cellBackgroundImageView setImage:cellTopImage];
    //        }
    //        else if (indexPath.row == [nutrientStandardArray count]-1)
    //        {
    //            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_bottom@2x" ofType:@"png"];
    //            UIImage * cellBottomImage = [UIImage imageWithContentsOfFile:path];
    //            [cell.cellBackgroundImageView setImage:cellBottomImage];
    //        }
    //        else
    //        {
    //            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_middle@2x" ofType:@"png"];
    //            UIImage * cellMiddleImage = [UIImage imageWithContentsOfFile:path];
    //            [cell.cellBackgroundImageView setImage:cellMiddleImage];
    //        }
    //        cell.nutritionNameLabel.text = nutrientName;
    //        cell.nutritionSupplyLabel.text = [NSString stringWithFormat:@"%.2f%@",[foodNutrientContent floatValue],unit];
    //
    //        return cell;
    //    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.section == 0)
    return 55;
    //    else
    //        return 30;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
