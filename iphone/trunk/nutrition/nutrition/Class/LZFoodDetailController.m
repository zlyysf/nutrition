//
//  LZFoodDetailController.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodDetailController.h"
#import "LZConstants.h"
#import "LZNutritionSupplyCell.h"
#import "LZStandardContentCell.h"
#import "LZUtility.h"
#import "GADMasterViewController.h"
#import "MobClick.h"

#define LongLineHeight 20.f
#define ShortLineHeight 10.f
#define ValuePickerHeight 50.f
#define GUnitWidth 8.f
#define UnitWidth 40.f
#define ValuePickerLabelFontSize 12.f
#define SingleLineWitdh 1.f
#define ValuePickerLabelWidth 36.f
@interface LZFoodDetailController ()
{
    BOOL isFirstLoad;
}

@end

@implementation LZFoodDetailController
@synthesize nutrientSupplyArray,nutrientStandardArray,foodName,UseUnitDisplay,sectionLabel,isUnitDisplayAvailable,gUnitMaxValue,unitMaxValue,currentSelectValue,isDefaultUnitDisplay,foodAttr,inOutParam,defaulSelectValue,delegate,unitName;
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
    self.title = foodName;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = saveItem;

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    self.listView.tableFooterView = footerView;
    self.foodValuePicker.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"valuepicker_bg.png"]];
    self.foodValuePicker.horizontalScrolling = YES;
    self.foodValuePicker.debugEnabled = NO;
    self.listView.hidden = YES;
    if(isUnitDisplayAvailable)
    {
        if (isDefaultUnitDisplay)
        {
            UseUnitDisplay = YES;
        }
        else
        {
            UseUnitDisplay = NO;
        }
    }
    else
    {
        UseUnitDisplay = NO;
    }
    isFirstLoad = YES;
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
                                                 self.foodAttr,@"FoodAttrs",
                                                 currentSelectValue,@"FoodAmount",
//                      self.foodAttr,@"dynamicFoodAttrs",
//                      currentSelectValue,@"dynamicFoodAmount",
                                                 nil];
    }
    [inOutParam setObject:currentSelectValue forKey:@"FoodAmount"];
    self.nutrientSupplyArray = [rf calculateGiveFoodSupplyNutrientAndFormatForUI:self.inOutParam];
    self.listView.hidden = NO;
    [self.listView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"食物详情页面"];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];
    [self setButtonState];

}
- (void)viewDidAppear:(BOOL)animated
{
    if (isFirstLoad)
    {
        [self firstDisplay];
    }
}
- (void)firstDisplay
{
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        int index = 0;
        int weight = [defaulSelectValue intValue];
        if (isUnitDisplayAvailable)
        {
            if(isDefaultUnitDisplay)
            {
                if(weight<= 0)
                {
                    index = 2;
                }
                else
                {
                    NSNumber *singleUnitWeight = [self.foodAttr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
                    index = ([defaulSelectValue intValue]*2)/[singleUnitWeight intValue] ;
                }
            }
            else
            {
                index = (weight<=0?100:weight);
            }
        }
        else
        {
            index = (weight<=0?100:weight);
            
        }
        [self.foodValuePicker setSelectedIndex:index];
    }
}
-(void)cancelButtonTapped
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)saveButtonTapped
{
    // if self.delegate
    if(self.delegate && [self.delegate respondsToSelector:@selector(didChangeFoodId:toAmount:)])
    {
        [self.delegate didChangeFoodId:[self.foodAttr objectForKey:@"NDB_No"] toAmount:currentSelectValue];
    }
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)setButtonState
{
    if (!isUnitDisplayAvailable)
    {
        self.UnitButton.hidden = YES;
        //self.GUnitButton.hidden = YES;
    }
    else
    {
        self.UnitButton.hidden = NO;
        [self.UnitButton setTitle:unitName forState:UIControlStateNormal];
        //self.GUnitButton.hidden = NO;
    }
    if (!UseUnitDisplay)
    {
        [self.UnitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.UnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_normal.png"] forState:UIControlStateNormal];
        [self.GUnitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.GUnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_clicked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.UnitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.UnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_clicked.png"] forState:UIControlStateNormal];
        [self.GUnitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.GUnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_normal.png"] forState:UIControlStateNormal];
    }
    [self.UnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_clicked.png"] forState:UIControlStateHighlighted];
    [self.GUnitButton setBackgroundImage:[UIImage imageNamed:@"unit_button_clicked.png"] forState:UIControlStateHighlighted];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"食物详情页面"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (nutrientSupplyArray != nil && [nutrientSupplyArray count]!=0)
        {
            return [nutrientSupplyArray count];
        }
        else
            return 0;
    }
    else
    {
        if (nutrientStandardArray != nil && [nutrientStandardArray count]!=0)
        {
            return [nutrientStandardArray count];
        }
        else
            return 0;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        LZNutritionSupplyCell *cell = (LZNutritionSupplyCell *)[tableView dequeueReusableCellWithIdentifier:@"LZNutritionSupplyCell"];
        NSDictionary *aNutrient = [nutrientSupplyArray objectAtIndex:indexPath.row];
        NSString *nutrientName = [aNutrient objectForKey:@"Name"];
        NSString *nutrientId = [aNutrient objectForKey:@"NutrientID"];
        UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:nutrientId];
        cell.nutrientId = nutrientId;
        [cell.nameButton setTitle:nutrientName forState:UIControlStateNormal];
        NSNumber *percent = [aNutrient objectForKey:@"1foodSupply1NutrientRate"];
        NSNumber *food1Supply1NutrientAmount = [aNutrient objectForKey:@"food1Supply1NutrientAmount"];
        NSNumber *nutrientTotalDRI = [aNutrient objectForKey:@"nutrientTotalDRI"];
        NSString *unit = [aNutrient objectForKey:@"Unit"];
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
        [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:7.f fillRadius:radius];

            cell.nutrientSupplyLabel.text = [NSString stringWithFormat:@"%d%% (%.2f/%.2f%@)",(int)([percent floatValue] *100),[food1Supply1NutrientAmount floatValue],[nutrientTotalDRI floatValue ],unit];
        return cell;
    }
    else
    {
        LZStandardContentCell *cell = (LZStandardContentCell *)[tableView dequeueReusableCellWithIdentifier:@"LZStandardContentCell"];
        NSDictionary *nutrientStandard = [nutrientStandardArray objectAtIndex:indexPath.row];
        NSString *nutrientName = [nutrientStandard objectForKey:@"Name"];
        NSNumber *foodNutrientContent = [nutrientStandard objectForKey:@"foodNutrientContent"];
        NSString *unit = [nutrientStandard objectForKey:@"Unit"];
        if (indexPath.row == 0)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_top@2x" ofType:@"png"];
            UIImage * cellTopImage = [UIImage imageWithContentsOfFile:path];

            [cell.cellBackgroundImageView setImage:cellTopImage];
        }
        else if (indexPath.row == [nutrientStandardArray count]-1)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_bottom@2x" ofType:@"png"];
            UIImage * cellBottomImage = [UIImage imageWithContentsOfFile:path];
            [cell.cellBackgroundImageView setImage:cellBottomImage];
        }
        else
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_middle@2x" ofType:@"png"];
            UIImage * cellMiddleImage = [UIImage imageWithContentsOfFile:path];
            [cell.cellBackgroundImageView setImage:cellMiddleImage];
        }
        cell.nutritionNameLabel.text = nutrientName;
        cell.nutritionSupplyLabel.text = [NSString stringWithFormat:@"%.2f%@",[foodNutrientContent floatValue],unit];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 42;
    else
        return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if( section == 0)
        return 5;
    else
        return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    float height = (section == 0 ?5:20);
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}// Default is 1 if not implemented
- (IBAction)gUnitButtonTapped:(UIButton *)sender
{
    if (!UseUnitDisplay)
    {
        return;
    }
    UseUnitDisplay = NO;
    [self setButtonState];
    [self.foodValuePicker reloadData];
    int index = 0;
    if (isDefaultUnitDisplay)
    {
        index = 100;
    }
    else
    {
        index = [defaulSelectValue intValue];
    }
    [self.foodValuePicker setSelectedIndex:index];
}
- (IBAction)unitButtonTapped:(UIButton *)sender
{
    if (UseUnitDisplay)
    {
        return;
    }
    UseUnitDisplay = YES;
    [self setButtonState];
    [self.foodValuePicker reloadData];
    int index = 0;
    if (isDefaultUnitDisplay)
    {
        NSNumber *singleUnitWeight = [self.foodAttr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
        index = ([defaulSelectValue intValue]*2)/[singleUnitWeight intValue] ;
        if (index <= 0)
        {
            index = 2;
        }
    }
    else
    {
        index = 2;
    }

    [self.foodValuePicker setSelectedIndex:index];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFoodValuePicker:nil];
    [self setFoodAmountDisplayLabel:nil];
    [self setGUnitButton:nil];
    [self setUnitButton:nil];
    [super viewDidUnload];
}
#pragma mark- LZValueSelectorViewDelegate
- (void)selector:(LZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index
{
    if ( UseUnitDisplay)
    {
        NSNumber *singleUnitWeight = [self.foodAttr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
        float value = ((float)index/2)*[singleUnitWeight intValue];
        currentSelectValue = [NSNumber numberWithFloat:value];
        if (index%2 == 0)
        {
            if ((value-(int)value)<Config_nearZero)
            {
                self.foodAmountDisplayLabel.text = [NSString stringWithFormat:@"%d%@(%d克)",(index/2),unitName,(int)value];
            }
            else
            {
                self.foodAmountDisplayLabel.text = [NSString stringWithFormat:@"%d%@(%.1f克)",(index/2),unitName,value];
            }
            
        }
        else
        {
            if ((value-(int)value)<Config_nearZero)
            {
                self.foodAmountDisplayLabel.text = [NSString stringWithFormat:@"%.1f%@(%d克)",((float)index/2),unitName,(int)value];
            }
            else
            {
                self.foodAmountDisplayLabel.text = [NSString stringWithFormat:@"%.1f%@(%.1f克)",((float)index/2),unitName,value];
            }
        }
    }
    else
    {
        currentSelectValue = [NSNumber numberWithFloat:index];
        self.foodAmountDisplayLabel.text = [NSString stringWithFormat:@"%d克",index ];
    }
    [self displayNutrientUI];
}

- (NSInteger)numberOfRowsInSelector:(LZValueSelectorView *)valueSelector
{
    if (UseUnitDisplay)
    {
        return [unitMaxValue intValue]+1;
    }
    return [gUnitMaxValue intValue]+1;
}
- (UIView *)selector:(LZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger) index
{
    if (UseUnitDisplay)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UnitWidth, ValuePickerHeight)];
        if (index %2 == 0)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0-(ValuePickerLabelWidth-UnitWidth)/2, 6, ValuePickerLabelWidth, ValuePickerLabelFontSize+3)];
            label.font = [UIFont systemFontOfSize:ValuePickerLabelFontSize];
            label.text = [NSString stringWithFormat:@"%d",index/2];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            [view addSubview:label];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake((UnitWidth-SingleLineWitdh)/2, ValuePickerHeight-LongLineHeight-3, SingleLineWitdh, LongLineHeight)];
            [line setBackgroundColor:[UIColor blackColor]];
            [view addSubview:line];
            
            
        }
        else
        {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake((UnitWidth-SingleLineWitdh)/2, ValuePickerHeight-ShortLineHeight-3, SingleLineWitdh, ShortLineHeight)];
            [line setBackgroundColor:[UIColor blackColor]];
            [view addSubview:line];
        }
        return view;
        
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GUnitWidth, ValuePickerHeight)];
        
        if (index %10 == 0)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0-(ValuePickerLabelWidth-GUnitWidth)/2, 6, ValuePickerLabelWidth, ValuePickerLabelFontSize+3)];
            label.font = [UIFont systemFontOfSize:ValuePickerLabelFontSize];
            label.text = [NSString stringWithFormat:@"%d",index ];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            [view addSubview:label];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake((GUnitWidth-SingleLineWitdh)/2,ValuePickerHeight-LongLineHeight-3, SingleLineWitdh, LongLineHeight)];
            [line setBackgroundColor:[UIColor blackColor]];
            [view addSubview:line];
            
            
        }
        else
        {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake((GUnitWidth-SingleLineWitdh)/2, ValuePickerHeight-ShortLineHeight-3, SingleLineWitdh, ShortLineHeight)];
            [line setBackgroundColor:[UIColor blackColor]];
            [view addSubview:line];
        }
        view.clipsToBounds = NO;
        
        return view;
    }
}
- (CGRect)rectForSelectionInSelector:(LZValueSelectorView *)valueSelector
{
    if(UseUnitDisplay)
    {
        return CGRectMake((320-UnitWidth)/2, 0, UnitWidth, ValuePickerHeight);
    }
    return CGRectMake((320-GUnitWidth)/2, 0, GUnitWidth, ValuePickerHeight);
}
- (CGFloat)rowHeightInSelector:(LZValueSelectorView *)valueSelector
{
    return ValuePickerHeight;
}
- (CGFloat)rowWidthInSelector:(LZValueSelectorView *)valueSelector
{
    if(UseUnitDisplay)
    {
        return UnitWidth;
    }
    return GUnitWidth;
}

@end
