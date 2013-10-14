//
//  LZFoodSearchViewController.m
//  nutrition
//
//  Created by liu miao on 8/29/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodSearchViewController.h"
#import "LZDataAccess.h"
#import "LZFoodTypeButton.h"
#import "LZDailyIntakeViewController.h"
#import "LZFoodDetailController.h"
#import "LZConstants.h"
#import "JWNavigationViewController.h"
#import "MobClick.h"
#import "GADMasterViewController.h"
#import "LZDietListMakeViewController.h"
@interface LZFoodSearchViewController ()<LZFoodDetailViewControllerDelegate>
{
    BOOL isfirstLoad;
}
@end

@implementation LZFoodSearchViewController
@synthesize allFood,foodNameArray,foodTypeArray,isFromOut,allFoodNamesArray,searchResultArray,admobView;
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
    isfirstLoad = YES;
    if (ViewControllerUseBackImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];

    }
    self.title = NSLocalizedString(@"foodsearch_viewtitle",@"食物");
    UISearchBar *searchBar = self.searchResultVC.searchBar;
    UIView *barBack = [searchBar.subviews objectAtIndex:0];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_bg.png"]];
    [barBack addSubview:bgImage];
    
    allFood = [[LZDataAccess singleton]getAllFood];
    NSMutableSet *foodTypeSet = [NSMutableSet set];
    self.foodTypeArray = [[NSMutableArray alloc]init];
    self.foodNameArray = [[NSMutableArray alloc]init];
    self.allFoodNamesArray = [[NSMutableArray alloc]init];
    self.searchResultArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< [allFood count]; i++)
    {
        NSDictionary *afood = [allFood objectAtIndex:i];
        NSString *foodType = [afood objectForKey:@"CnType"];
        [allFoodNamesArray addObject:[afood objectForKey:@"CnCaption"]];
        if (![foodTypeSet containsObject:foodType])
        {
            NSMutableArray *foodName = [[NSMutableArray alloc]init];
            [foodName addObject:afood];
            [self.foodNameArray addObject:foodName];
            [self.foodTypeArray addObject:foodType];
            [foodTypeSet addObject:foodType];
        }
        else
        {
            int index = [self.foodTypeArray indexOfObject:foodType];
            [[self.foodNameArray objectAtIndex:index]addObject:afood];
        }
    }
    int totalFloor = [foodTypeArray count]/3+ (([foodTypeArray count]%3 == 0)?0:1);
    float scrollHeight = totalFloor *94 + 20+ (totalFloor-1)*8+50;
    self.admobView = [[UIView alloc]initWithFrame:CGRectMake(0, scrollHeight-50, 320, 50)];
    [self.listView addSubview:self.admobView];
    [self.listView setContentSize:CGSizeMake(320, scrollHeight)];
    [self.searchResultVC.searchBar setPlaceholder:NSLocalizedString(@"foodsearch_searchbar_placeholder",@"快速查找食物")];
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:UmengPathShiWuChaXun];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];
    if (isfirstLoad)
    {
        isfirstLoad = NO;
        [self setButtons];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathShiWuChaXun];
}
-(void)setButtons
{
    float startY = 10;
    int floor = 1;
    int perRowCount = 3;
    float startX;
    for (int i=0; i< [self.foodTypeArray count]; i++)
    {

        if (i>=floor *perRowCount)
        {
            floor+=1;
        }
        startX = 10+(i-(floor-1)*perRowCount)*102;
        NSString *typeName = [self.foodTypeArray objectAtIndex:i];
        LZFoodTypeButton *button = [[LZFoodTypeButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*102, 94, 94)];
        [self.listView addSubview:button];
        //button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",typeName]] forState:UIControlStateNormal];
        button.tag = i+100;
        [button addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button.typeLabel setText:typeName];
    }
}

-(void)cancelButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:NO];
    return YES;

}
-(void)typeButtonTapped:(UIButton *)sender
{
    int tag = sender.tag -100;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZDailyIntakeViewController *dailyIntakeViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDailyIntakeViewController"];
    dailyIntakeViewController.foodArray = [self.foodNameArray objectAtIndex:tag];
    //dailyIntakeViewController.foodIntakeDictionary = self.foodIntakeDictionary;
    dailyIntakeViewController.titleString = [self.foodTypeArray objectAtIndex:tag];
    dailyIntakeViewController.isFromOut = isFromOut;
    [self.navigationController pushViewController:dailyIntakeViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
        return [self.searchResultArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	NSDictionary *resultDict = [self.searchResultArray objectAtIndex:indexPath.row];
    NSString *picturePath;
    NSString *picPath = [resultDict objectForKey:@"PicPath"];
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
    [cell.imageView setImage:foodImage];
	cell.textLabel.text = [resultDict objectForKey:@"CnCaption"];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchResultVC setActive:NO];
    [self.searchResultVC.searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *resultDict = [self.searchResultArray objectAtIndex:indexPath.row];
    NSString *resultName = [resultDict objectForKey:@"CnCaption"];
    
    int index = [self.allFoodNamesArray indexOfObject:resultName];
    NSDictionary *foodAtr = [self.allFood  objectAtIndex:index];
    NSString *foodName = [foodAtr objectForKey:@"CnCaption"];
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
        foodDetailController.isDefaultUnitDisplay = NO;
        int maxCount = (int)(ceilf(([upper floatValue]*2)/[singleUnitWeight floatValue]));
        foodDetailController.unitMaxValue = [NSNumber numberWithInt:maxCount];
    }
    foodDetailController.isPushToDietPicker = isFromOut;
    foodDetailController.currentSelectValue = weight;
    foodDetailController.defaulSelectValue = weight;
    foodDetailController.foodAttr = foodAtr;
    foodDetailController.foodName = foodName;
    if(!isFromOut)
    {
       foodDetailController.delegate = self; 
    }
    foodDetailController.isCalForAll = NO;
    foodDetailController.GUnitStartIndex = 100;
    JWNavigationViewController *nav = [[JWNavigationViewController alloc]initWithRootViewController:foodDetailController];
    [self presentModalViewController:nav animated:YES];
}
#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchResultArray removeAllObjects];
//    NSLog(@"%@",searchString);
    for (int i=0; i<[self.allFoodNamesArray count]; i++)
    {
        NSString *cnName = [self.allFoodNamesArray objectAtIndex:i];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchString];
        if ([pre evaluateWithObject:cnName])
        {
            NSDictionary *afood = [allFood objectAtIndex:i];
            NSString *picPath = [afood objectForKey:@"PicPath"];
            NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:cnName ,@"CnCaption",picPath,@"PicPath", nil];
            [self.searchResultArray addObject:resultDict];
        }
    
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    	
    [self.searchResultVC.searchBar resignFirstResponder];
}


#pragma mark- LZFoodDetailViewControllerDelegate
-(void)didChangeFoodId:(NSString *)foodId toAmount:(NSNumber*)changedValue
{
    [LZUtility addFood:foodId withFoodAmount:changedValue];
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isMemberOfClass:[LZDietListMakeViewController class]])
        {
            [self.navigationController popToViewController:vc animated:NO];
            break;
        }
    }

}

- (void)viewDidUnload {
    [self setSearchResultVC:nil];
    [self setListView:nil];
    [super viewDidUnload];
}
@end
