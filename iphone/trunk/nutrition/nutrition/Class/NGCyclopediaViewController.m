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
    nutritionCellHeight = 370.f;
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
    if (indexPath.section == 0)
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
    else if (indexPath.section == 1)
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
        return diseaseCellHeight;
    }
    else if (indexPath.section == 1)
    {
        return nutritionCellHeight;
    }
    else
    {
        return foodCellHeight;
    }
}

@end
