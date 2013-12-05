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
#import "NGFoodListViewController.h"
#import "LZCustomDataButton.h"
#import "LZNutrientionManager.h"
#import "LZUtility.h"
#import "NGIllnessInfoViewController.h"
#import "NGNutritionInfoViewController.h"
#define DiseaseItemTopMargin 10
#define DiseaseItemMargin 9
#define DiseaseItemBottomMarigin 40
#define DiseaseItemLabelHeight 36
#define DiseaseItemLabelStartX 70
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
    LZDataAccess *da = [LZDataAccess singleton];
    self.commonDiseaseArray = [da getAllIllness];
    self.nutritionArray = [LZRecommendFood getCustomNutrients:nil];
    self.foodArray = [da getFoodCnTypes];
    //@"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",
    //@"Riboflavin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",@"Vit_B12_(µg)",
    //@"Calcium_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Zinc_(mg)",@"Potassium_(mg)",
    //@"Fiber_TD_(g)",@"Protein_(g)"
    self.nutritionVitaminArray = [NSArray arrayWithObjects:@"Vit_A_RAE",@"Riboflavin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",@"Vit_B12_(µg)",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)", nil];
    self.nutritionMineralArray = [NSArray arrayWithObjects:@"Iron_(mg)",@"Calcium_(mg)",@"Magnesium_(mg)",@"Potassium_(mg)",@"Zinc_(mg)", nil];
    self.nutritionOtherArray = [NSArray arrayWithObjects:@"Protein_(g)",@"Fiber_TD_(g)", nil];
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
-(NSString *)getNutritionName:(NSString *)nutritionId
{
    LZNutrientionManager*nm = [LZNutrientionManager SharedInstance];
    NSDictionary *dict = [nm getNutritionInfo:nutritionId];
    //UIColor *backColor = [LZUtility getNutrientColorForNutrientId:nutritionId];
    //NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
    NSString *queryKey;
    if (isChinese)
    {
        queryKey = @"IconTitleCn";
    }
    else
    {
        queryKey = @"IconTitleEn";
    }
    NSString *nutritionName = [dict objectForKey:queryKey];
    return nutritionName;

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
                NSDictionary *illnessDict = [self.commonDiseaseArray objectAtIndex:i];
                NSString *illnessId = [illnessDict objectForKey:@"IllnessId"];
                NSString *illnessName;
                if (isChinese) {
                    illnessName =[illnessDict objectForKey:@"IllnessNameCn"];
                }
                else
                {
                    illnessName =[illnessDict objectForKey:@"IllnessNameEn"];
                }
                LZCustomDataButton *illnessButton = [[LZCustomDataButton alloc]initWithFrame:CGRectMake(DiseaseItemLabelStartX, 30+DiseaseItemTopMargin+i*(DiseaseItemLabelHeight+DiseaseItemMargin), 160, DiseaseItemLabelHeight)];
                [cell.backView addSubview:illnessButton];
                illnessButton.customData = illnessId;
                [illnessButton addTarget:self action:@selector(illnessButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [illnessButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [illnessButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
                [illnessButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [illnessButton setTitle:illnessName forState:UIControlStateNormal];
            
                UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DiseaseDetailArrowStartX, 0, 20, 20)];
                [cell.backView addSubview:arrowImage];
                CGPoint potentialLabelCenter = illnessButton.center;
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
                LZCustomDataButton *button = [[LZCustomDataButton alloc]initWithFrame:CGRectMake(startX,startY, 40, 30)];
                [cell.backView addSubview:button];
                //button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
                NSString *nutritionId =[self.nutritionVitaminArray objectAtIndex:i];
                [button setBackgroundColor:[LZUtility getNutrientColorForNutrientId:nutritionId]];
                button.customData = nutritionId;
                [button addTarget:self action:@selector(nutritionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                NSString *nutritionName = [self getNutritionName:nutritionId];
                [button setTitle:nutritionName forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
                
                LZCustomDataButton *button = [[LZCustomDataButton alloc]initWithFrame:CGRectMake(startX,startY, 40, 30)];
                [cell.backView addSubview:button];
                //button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
                NSString *nutritionId =[self.nutritionMineralArray objectAtIndex:i];
                [button setBackgroundColor:[LZUtility getNutrientColorForNutrientId:nutritionId]];
                button.customData = nutritionId;
                [button addTarget:self action:@selector(nutritionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                NSString *nutritionName = [self getNutritionName:nutritionId];
                [button setTitle:nutritionName forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
                
                LZCustomDataButton *button = [[LZCustomDataButton alloc]initWithFrame:CGRectMake(startX,startY, 60, 30)];
                [cell.backView addSubview:button];
                //button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
                
                NSString *nutritionId =[self.nutritionOtherArray objectAtIndex:i];
                [button setBackgroundColor:[LZUtility getNutrientColorForNutrientId:nutritionId]];
                button.customData = nutritionId;
                [button addTarget:self action:@selector(nutritionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                NSString *nutritionName = [self getNutritionName:nutritionId];
                [button setTitle:nutritionName forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
-(void)nutritionButtonClicked:(LZCustomDataButton *)sender
{
    NSString *nutritionId = (NSString *)sender.customData;
    NSLog(@"%@",nutritionId);
    LZNutrientionManager *nm = [LZNutrientionManager SharedInstance];
    NSDictionary *dict = [nm getNutritionInfo:nutritionId];
    NSString *captionKey;
//    NSString *descriptionKey;
    if ([LZUtility isCurrentLanguageChinese])
    {
        captionKey = @"NutrientCnCaption";
//        descriptionKey = @"NutrientDescription";
    }
    else
    {
        captionKey = @"NutrientEnCaption";
//        descriptionKey = @"NutrientDescriptionEn";
    }
//    NSString *description = [dict objectForKey:descriptionKey];
    NSString *nutritionName = [dict objectForKey:captionKey];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGNutritionInfoViewController *nutritionInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGNutritionInfoViewController"];
    nutritionInfoViewController.title =nutritionName;
    nutritionInfoViewController.nutrientDict = dict;
 //   nutritionInfoViewController.nutritionDescription = description;
//    richNutrientController.nutrientDict = dict;
//    richNutrientController.nutrientTitle = nutritionName;
//    richNutrientController.nutritionDescription = description;
    [self.navigationController pushViewController:nutritionInfoViewController animated:YES];
}
-(void)illnessButtonClicked:(LZCustomDataButton *)sender
{
    NSString *illnessId = (NSString *)sender.customData;
    NSLog(@"%@",illnessId);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGIllnessInfoViewController *illnessInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGIllnessInfoViewController"];
    illnessInfoViewController.illnessURL = @"http://www.baidu.com";
    illnessInfoViewController.title = illnessId;
    [self.navigationController pushViewController:illnessInfoViewController animated:YES];

    
}
-(void)typeButtonTapped:(LZFoodTypeButton *)sender
{
    int tag = sender.tag -100;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGFoodListViewController *foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGFoodListViewController"];
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
    
    foodListViewController.foodArray = [da getFoodsByShowingPart:nil andEnNamePart:nil andCnType:typeKey];//[self.foodNameArray objectAtIndex:tag];
    //dailyIntakeViewController.foodIntakeDictionary = self.foodIntakeDictionary;
    foodListViewController.title = typeName;
    [self.navigationController pushViewController:foodListViewController animated:YES];
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
