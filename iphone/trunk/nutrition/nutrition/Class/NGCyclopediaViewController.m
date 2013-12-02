//
//  NGCyclopediaViewController.m
//  nutrition
//
//  Created by liu miao on 11/25/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGCyclopediaViewController.h"
#import "NGCommonDiseaseCell.h"
#import "NGFoodsCell.h"
#import "NGNutritionCell.h"
#import "LZRecommendFood.h"
#import "LZConstants.h"
#import "LZFoodTypeButton.h"
#import "LZDailyIntakeViewController.h"
#define DiseaseItemTopMargin 10
#define DiseaseItemMargin 9
#define DiseaseItemBottomMarigin 40
#define DiseaseItemLabelHeight 36
#define DiseaseItemLabelStartX 90
#define DiseaseDetailArrowStartX 261
#define FoodItemMargin 20
@interface NGCyclopediaViewController ()
{
    BOOL isChinese;
}
@property (nonatomic,assign)float diseaseCellHeight;
@property (nonatomic,assign)float nutritionCellHeight;
@property (nonatomic,assign)float foodCellHeight;
@end

@implementation NGCyclopediaViewController
@synthesize commonDiseaseArray,nutritionArray,foodArray,diseaseCellHeight,nutritionCellHeight,foodCellHeight;
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
    if ([LZUtility isCurrentLanguageChinese])
    {
        isChinese = YES;
    }
    else{
        isChinese = NO;
    }

    self.commonDiseaseArray = [NSArray arrayWithObjects:@"急性咽炎",@"关节炎",@"流行性感冒",@"急性胃炎",nil];
    self.nutritionArray = [LZRecommendFood getCustomNutrients:nil];
    self.foodArray = [[LZDataAccess singleton]getFoodCnTypes];
    self.nutritionVitaminArray = [NSArray arrayWithObjects:@"A",@"B2",@"B6",@"B9",@"B12",@"C",@"D",@"E", nil];
    self.nutritionMineralArray = [NSArray arrayWithObjects:@"铁",@"钙",@"镁",@"钾",@"锌", nil];
    self.nutritionOtherArray = [NSArray arrayWithObjects:@"蛋白质",@"纤维", nil];
    int count1 = [self.nutritionVitaminArray count];
    int count2 = [self. nutritionMineralArray count];
    int count3 = [self.nutritionOtherArray count];
    int floor1 = count1/4+ ((count1%4 == 0)?0:1);
    int floor2 = count2/4+ ((count2%4 == 0)?0:1);
    int floor3 = count3/2+ ((count3%2 == 0)?0:1);
    nutritionCellHeight = (floor1+floor2+floor3)*(50)+110;
    int diseaseCount = [commonDiseaseArray count];
    diseaseCellHeight = 40+30+DiseaseItemTopMargin+diseaseCount*(DiseaseItemLabelHeight+DiseaseItemMargin)-DiseaseItemMargin+DiseaseItemBottomMarigin;
    int foodCount = [foodArray count];
    int totalFloor = foodCount/3+ ((foodCount%3 == 0)?0:1);
    foodCellHeight = 20+30+ totalFloor*(80+FoodItemMargin)+FoodItemMargin;
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        NGCommonDiseaseCell *cell =(NGCommonDiseaseCell*) [self.listView dequeueReusableCellWithIdentifier:@"NGCommonDiseaseCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            cell.hasLoaded = YES;
            [cell.headerLabel.layer setBorderWidth:0.5f];
            [cell.backView.layer setBorderWidth:0.5f];
            [cell.headerLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.headerLabel setBackgroundColor:[UIColor colorWithRed:236/255.f green:240/255.f blue:232/255.f alpha:1.0f]];
            cell.headerLabel.text = @"  常见疾病";
            for (int i =0 ; i< [self.commonDiseaseArray count]; i++)
            {
                UILabel *diseaseItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(DiseaseItemLabelStartX, 30+DiseaseItemTopMargin+i*(DiseaseItemLabelHeight+DiseaseItemMargin), 140, DiseaseItemLabelHeight)];
                [cell.backView addSubview:diseaseItemLabel];
                diseaseItemLabel.text = [self.commonDiseaseArray objectAtIndex:i];
                [diseaseItemLabel setFont:[UIFont systemFontOfSize:22]];
                [diseaseItemLabel setTextColor:[UIColor blackColor]];
                [diseaseItemLabel setBackgroundColor:[UIColor clearColor]];
                UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DiseaseDetailArrowStartX, 0, 20, 20)];
                [cell.backView addSubview:arrowImage];
                CGPoint potentialLabelCenter = diseaseItemLabel.center;
                CGPoint arrowCenter = CGPointMake(arrowImage.center.x, potentialLabelCenter.y);
                arrowImage.center = arrowCenter;
                [arrowImage setImage:[UIImage imageNamed:@"item_detail_arrow.png"]];
            }

            return cell;
        }
    }
    else if (indexPath.section == 0)
    {
        NGNutritionCell *cell = (NGNutritionCell*)[self.listView dequeueReusableCellWithIdentifier:@"NGNutritionCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            cell.hasLoaded = YES;
            [cell.headerLabel setBackgroundColor:[UIColor colorWithRed:236/255.f green:171/255.f blue:162/255.f alpha:1.0f]];
            [cell.headerLabel.layer setBorderWidth:0.5f];
            [cell.backView.layer setBorderWidth:0.5f];
            [cell.headerLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.headerLabel setBackgroundColor:[UIColor colorWithRed:236/255.f green:240/255.f blue:232/255.f alpha:1.0f]];
            cell.headerLabel.text = @"  营养";
            float startY = 50;
            int floor = 1;
            int perRowCount = 4;
            float startX;
            for (int i=0; i< [self.nutritionVitaminArray count]; i++)
            {
                
                if (i>=floor *perRowCount)
                {
                    floor+=1;
                    startY += 50;
                }
                startX = 80+(i-(floor-1)*perRowCount)*55;
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(startX,startY, 40, 30)];
                [cell.backView addSubview:button];
                //button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
                [button setBackgroundColor:[UIColor lightGrayColor]];
                [button setTitle:[self.nutritionVitaminArray objectAtIndex:i] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [button.titleLabel setTextColor:[UIColor blackColor]];
                [button.layer setMasksToBounds:YES];
                [button.layer setCornerRadius:3];
                
            }
            startY += 50;
            float part1Height =startY-30;
            float vitaminLabelY = (part1Height-20)/2+30;
            [cell.vitaminLabel setFrame:CGRectMake(10, vitaminLabelY, 60, 20)];
            
            [cell.vitaminLabel setText:@"维生素"];
            [cell.sepline1View setFrame:CGRectMake(0, startY, 300, 1)];
            
            startY += 20;
            floor = 1;
            for (int i=0; i< [self.nutritionMineralArray count]; i++)
            {
                
                if (i>=floor *perRowCount)
                {
                    startY += 50;
                    floor+=1;
                }
                startX = 80+(i-(floor-1)*perRowCount)*55;
                
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(startX,startY, 40, 30)];
                [cell.backView addSubview:button];
                //button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
                [button setBackgroundColor:[UIColor lightGrayColor]];
                [button setTitle:[self.nutritionMineralArray objectAtIndex:i] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [button.titleLabel setTextColor:[UIColor blackColor]];
                [button.layer setMasksToBounds:YES];
                [button.layer setCornerRadius:3];
                
            }
            startY += 50;
            float part2Height = startY-30-part1Height;
            float mineralLabelY = (part2Height-20)/2+30+part1Height;
            [cell.mineralLabel setFrame:CGRectMake(10, mineralLabelY, 60, 20)];
            
            [cell.mineralLabel setText:@"矿物质"];
            [cell.sepline2View setFrame:CGRectMake(0, startY, 300, 1)];
            startY += 20;
            floor = 1;
            perRowCount = 2;
            for (int i=0; i< [self.nutritionOtherArray count]; i++)
            {
                
                if (i>=floor *perRowCount)
                {
                    startY += 50;
                    floor+=1;
                }
                startX = 80+(i-(floor-1)*perRowCount)*90;
                
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(startX,startY, 60, 30)];
                [cell.backView addSubview:button];
                //button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
                [button setBackgroundColor:[UIColor lightGrayColor]];
                [button setTitle:[self.nutritionOtherArray objectAtIndex:i] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [button.titleLabel setTextColor:[UIColor blackColor]];
                [button.layer setMasksToBounds:YES];
                [button.layer setCornerRadius:3];
                
            }

            return cell;
        }
    }
    else
    {
        NGFoodsCell *cell = (NGFoodsCell*)[self.listView dequeueReusableCellWithIdentifier:@"NGFoodsCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            cell.hasLoaded = YES;
            [cell.headerLabel.layer setBorderWidth:0.5f];
            [cell.backView.layer setBorderWidth:0.5f];
            [cell.headerLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.headerLabel setBackgroundColor:[UIColor colorWithRed:236/255.f green:240/255.f blue:232/255.f alpha:1.0f]];
            cell.headerLabel.text = @"  食物";
            float startY = 50;
            int floor = 1;
            int perRowCount = 3;
            float startX;
            for (int i=0; i< [self.foodArray count]; i++)
            {
                
                if (i>=floor *perRowCount)
                {
                    floor+=1;
                }
                startX = 10+(i-(floor-1)*perRowCount)*100;
                LZDataAccess *da = [LZDataAccess singleton];
                NSDictionary *translationItemInfo2LevelDict = [da getTranslationItemsDictionaryByType:TranslationItemType_FoodCnType];
                NSString *typeKey = [self.foodArray objectAtIndex:i];
                NSDictionary *typeDict = [translationItemInfo2LevelDict objectForKey:typeKey];
                NSString *queryKey;
                if (isChinese)
                {
                    queryKey = @"ItemNameCn";
                }
                else
                {
                    queryKey = @"ItemNameEn";
                }
                
                NSString *typeName = [typeDict objectForKey:queryKey];
                LZFoodTypeButton *button = [[LZFoodTypeButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*100, 80, 80)];
                [cell.backView addSubview:button];
                //button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
                [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",typeKey]] forState:UIControlStateNormal];
                button.tag = i+100;
                [button addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [button.typeLabel setText:typeName];
            }

            return cell;
        }
    }
}
-(void)typeButtonTapped:(UIButton *)sender
{
    int tag = sender.tag -100;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZDailyIntakeViewController *dailyIntakeViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDailyIntakeViewController"];
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *translationItemInfo2LevelDict = [da getTranslationItemsDictionaryByType:TranslationItemType_FoodCnType];
    NSString *typeKey = [self.foodArray objectAtIndex:tag];
    NSDictionary *typeDict = [translationItemInfo2LevelDict objectForKey:typeKey];
    NSString *queryKey;
    if (isChinese)
    {
        queryKey = @"ItemNameCn";
    }
    else
    {
        queryKey = @"ItemNameEn";
    }
    
    NSString *typeName = [typeDict objectForKey:queryKey];
    
    dailyIntakeViewController.foodArray = [da getFoodsByShowingPart:nil andEnNamePart:nil andCnType:typeKey];//[self.foodNameArray objectAtIndex:tag];
    //dailyIntakeViewController.foodIntakeDictionary = self.foodIntakeDictionary;
    dailyIntakeViewController.titleString = typeName;
    dailyIntakeViewController.isFromOut = NO;
    [self.navigationController pushViewController:dailyIntakeViewController animated:YES];
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return nutritionCellHeight;
    }
    else if (indexPath.section == 1)
    {
        return foodCellHeight;
    }
    else
    {
        return diseaseCellHeight;
    }
}

@end
