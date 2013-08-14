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

@end

@implementation LZFoodDetailController
@synthesize nutrientSupplyArray,nutrientStandardArray,foodName,sectionTitle,UseUnitDisplay,sectionLabel;
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
//    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setTitle:@"  返回" forState:UIControlStateNormal];
//    
//    button.frame = CGRectMake(0, 0, 48, 30);
//    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
//    [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    self.navItem.leftBarButtonItem= customBarItem;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    self.listView.tableFooterView = footerView;
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 32)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    self.sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 27)];
//    [sectionLabel setTextColor:[UIColor blackColor]];
//    [sectionLabel setFont:[UIFont boldSystemFontOfSize:14]];
//    [sectionLabel setBackgroundColor:[UIColor clearColor]];
//    [sectionView addSubview:sectionLabel];
    //sectionLabel.text = [NSString stringWithFormat:@"一天的营养比例",self.sectionTitle];
    //self.listView.tableHeaderView = sectionView;
    self.foodValuePicker.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"valuepicker_bg.png"]];
    self.foodValuePicker.horizontalScrolling = YES;
    self.foodValuePicker.debugEnabled = NO;
    UseUnitDisplay = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"食物详情页面"];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];
    [self setButtonState];
}
-(void)setButtonState
{
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
}
- (void)viewDidAppear:(BOOL)animated
{
    if(UseUnitDisplay)
    {
        [self.foodValuePicker setSelectedIndex:1*2];
    }
    else
    {
        [self.foodValuePicker setSelectedIndex:100];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"食物详情页面"];
}
//- (void)backButtonTapped:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
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

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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
        //[cell adjustLabelAccordingToProgress:0.5];
//        if(KeyIsEnvironmentDebug)
//        {
            cell.nutrientSupplyLabel.text = [NSString stringWithFormat:@"%d%% (%.2f/%.2f%@)",(int)([percent floatValue] *100),[food1Supply1NutrientAmount floatValue],[nutrientTotalDRI floatValue ],unit];
//        }
//        else
//        {
//            cell.nutrientSupplyLabel.text = [NSString stringWithFormat:@"%d%% (%.2f/%.2f%@)",(int)(progress *100),[food1Supply1NutrientAmount floatValue],[nutrientTotalDRI floatValue ],unit];
//        }


//        UIView *tempView = [[UIView alloc] init];
//        [cell setBackgroundView:tempView];
//        [cell setBackgroundColor:[UIColor clearColor]];

        //[cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:[UIColor greenColor] progress:0.5 withRadius:8];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if( section == 0)
//        return 32;
//    else
//        return 47;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if( section == 0)
        return 5;
    else
        return 20;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    float height = (section ==0 ? 32 :47);
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    
////    UIImageView *sectionBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
////    [sectionView addSubview:sectionBarView];
////    NSString *path = [[NSBundle mainBundle] pathForResource:@"section_bar@2x" ofType:@"png"];
////    UIImage * sectionBarImage = [UIImage imageWithContentsOfFile:path];
////    [sectionBarView setImage:sectionBarImage];
//    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 27)];
//    [sectionTitleLabel setTextColor:[UIColor blackColor]];
//    [sectionTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
//    [sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
//    [sectionView addSubview:sectionTitleLabel];
//    
//    if (section == 0)
//        sectionTitleLabel.text = [NSString stringWithFormat:@"%@的一天营养比例",self.sectionTitle];
//    else
//        sectionTitleLabel.text = [NSString stringWithFormat:@"%@的营养成分标准含量(100g)",self.foodName];
//    return sectionView;
//}
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
        self.foodAmountDisplayLabel.text = [NSString stringWithFormat:@"%.1f个",((float)index/2) ];
        //sectionLabel.text = [NSString stringWithFormat:@"%.1f个%@的一天营养比例",((float)index/2),self.title];
    }
    else
    {
        self.foodAmountDisplayLabel.text = [NSString stringWithFormat:@"%d克",index ];
        //sectionLabel.text = [NSString stringWithFormat:@"%d克%@的一天营养比例",index,self.title];
    }
}

- (NSInteger)numberOfRowsInSelector:(LZValueSelectorView *)valueSelector
{
    if (UseUnitDisplay)
    {
        return 201;
    }
    return 1001;
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
