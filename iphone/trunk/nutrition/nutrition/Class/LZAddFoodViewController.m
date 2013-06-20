//
//  LZAddFoodViewController.m
//  nutrition
//
//  Created by liu miao on 6/20/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZAddFoodViewController.h"
#import "LZAddFoodCell.h"
#import "LZDataAccess.h"
#import "LZConstants.h"
#import "LZDailyIntakeViewController.h"
@interface LZAddFoodViewController ()

@end

@implementation LZAddFoodViewController
@synthesize foodTypeArray,foodIntakeDictionary,allFood,foodNameArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"food intake dict %@",foodIntakeDictionary);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    [[LZDataAccess singleton]getAllFood];
    allFood = [[LZDataAccess singleton]getAllFood];
    NSMutableSet *foodTypeSet = [NSMutableSet set];
    self.foodTypeArray = [[NSMutableArray alloc]init];
    self.foodNameArray = [[NSMutableArray alloc]init];
    NSDictionary *dailyIntake = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
    
    self.foodIntakeDictionary = [[NSMutableDictionary alloc]init];
    for (int i = 0; i< [allFood count]; i++)
    {
        NSDictionary *afood = [allFood objectAtIndex:i];
        NSString *foodType = [afood objectForKey:@"CnType"];
        NSString *NDB_No = [afood objectForKey:@"NDB_No"];
        if (dailyIntake != nil)
        {
            NSNumber *intakeNumber = [dailyIntake objectForKey:NDB_No];
            if (intakeNumber)
            {
                [self.foodIntakeDictionary setObject:intakeNumber forKey:NDB_No];
            }
            else
            {
                [self.foodIntakeDictionary setObject:[NSNumber numberWithInt:0] forKey:NDB_No];
            }
        }
        else
        {
            [self.foodIntakeDictionary setObject:[NSNumber numberWithInt:0] forKey:NDB_No];
        }
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

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.foodTypeArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZAddFoodCell * cell =(LZAddFoodCell*)[tableView dequeueReusableCellWithIdentifier:@"LZAddFoodCell"];
    cell.foodTypeNameLabel.text = [self.foodTypeArray objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.listView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZDailyIntakeViewController *dailyIntakeViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDailyIntakeViewController"];
    dailyIntakeViewController.foodArray = [self.foodNameArray objectAtIndex:indexPath.row];
    dailyIntakeViewController.foodIntakeDictionary = self.foodIntakeDictionary;
    dailyIntakeViewController.titleString = [self.foodTypeArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dailyIntakeViewController animated:YES];
}
- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)saveButtonTapped:(id)sender
{
    NSMutableDictionary *intakeDict = [[NSMutableDictionary alloc]init];
    BOOL needSaveData = NO;
    for (NSString * NDB_No in [self.foodIntakeDictionary allKeys])
    {
        NSNumber *num = [self.foodIntakeDictionary objectForKey:NDB_No];
        if ([num intValue]>=0)
        {
            needSaveData = YES;
            if  ([num intValue]>0)
            {
                [intakeDict setObject:num forKey:NDB_No];
            }
        }
    }
    if (needSaveData) {
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodChangedKey object:nil userInfo:nil];
        [[NSUserDefaults standardUserDefaults]setObject:intakeDict forKey:LZUserDailyIntakeKey];
        [[NSUserDefaults  standardUserDefaults]synchronize];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
@end
