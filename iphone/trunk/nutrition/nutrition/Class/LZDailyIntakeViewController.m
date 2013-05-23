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
@interface LZDailyIntakeViewController ()<LZFoodCellDelegate>

@end

@implementation LZDailyIntakeViewController
@synthesize foodIntakeDictionary,foodNameArray,foodTypeArray,foodSearchBar,foodSearchDisplayController,searchResultArray,allFood;
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
    //获取食物名称 初始化foodNameArray 和 foodIntakeAmountArray
    allFood = [[LZDataAccess singleton]getAllFood];
    NSMutableSet *foodTypeSet = [NSMutableSet set];
    self.foodTypeArray = [[NSMutableArray alloc]init];
    self.foodNameArray = [[NSMutableArray alloc]init];
    self.searchResultArray = [[NSMutableArray alloc]init];
    NSDictionary *dailyIntake = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];

    self.foodIntakeDictionary = [[NSMutableDictionary alloc]init];
    for (int i = 0; i< [allFood count]; i++)
    {
        NSDictionary *afood = [allFood objectAtIndex:i];
        NSString *foodType = [afood objectForKey:@"CnType"];
        NSString *NDB_No = [afood objectForKey:@"NDB_No"];
        if (dailyIntake != NULL)
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
    NSLog(@"footypearray %@, foodtypeset %@",self.foodTypeArray,foodTypeSet);

    NSLog(@"foodnamearray %@",self.foodNameArray);
    
    foodSearchBar = [[UISearchBar alloc]init];
    foodSearchBar.delegate = self;
    [foodSearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [foodSearchBar sizeToFit];
    self.listView.tableHeaderView = foodSearchBar;
    
    foodSearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:foodSearchBar contentsController:self];
    foodSearchDisplayController.delegate = self;
    foodSearchDisplayController.searchResultsDataSource = self;
    foodSearchDisplayController.searchResultsDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == foodSearchDisplayController.searchResultsTableView)
    {
        NSLog(@"searchResultArray %@",self.searchResultArray);
        return [self.searchResultArray count];
    }

    return [(NSMutableArray*)[self.foodNameArray objectAtIndex:section]count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == foodSearchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    return [self.foodTypeArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == foodSearchDisplayController.searchResultsTableView)
    {
        return @"";
    }
    return (NSString*)[self.foodTypeArray objectAtIndex:section];
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == foodSearchDisplayController.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[searchResultArray objectAtIndex:indexPath.row]objectForKey:@"CnCaption"];
        return cell;
    }
    else
    {
        LZFoodCell* cell =[tableView dequeueReusableCellWithIdentifier:@"FoodCell"];
        cell.delegate = self;
        cell.cellIndexPath = indexPath;
        //一个记录名称的数组 一个记录对应摄入量的数组
        NSDictionary *aFood = [[self.foodNameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.foodNameLabel.text = [aFood objectForKey:@"CnCaption"];//NDB_No
        NSString *NDB_No = [aFood objectForKey:@"NDB_No"];
        NSNumber *intake = [self.foodIntakeDictionary objectForKey:NDB_No];
        cell.intakeAmountTextField.text = [NSString stringWithFormat:@"%d",[intake intValue]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == foodSearchDisplayController.searchResultsTableView)
    {
        NSDictionary *aFood = [self.searchResultArray objectAtIndex:indexPath.row];
        NSString *aFoodType = [aFood objectForKey:@"CnType"];
        int section= -1;
        int row= -1;
        NSLog(@"%@",aFood);
        for (NSString *type in self.foodTypeArray)
        {
            if([type isEqualToString:aFoodType])
            {
                section = [self.foodTypeArray indexOfObject:type];
                break;
            }

        }

        if (section >=0 && section<[self.foodNameArray count]) {
            NSArray *subArray = [self.foodNameArray objectAtIndex:section];
            for (NSDictionary *dict in subArray)
            {
                if ([[dict objectForKey:@"CnType"]isEqualToString:aFoodType])
                {
                    row = [self.foodNameArray indexOfObject:dict];
                    break;
                }
            }
        }
        if (section >= 0 && row >= 0)
        {
            [foodSearchBar resignFirstResponder];
            NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:section];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.listView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            });
            
        }
    }
}
- (IBAction)saveButtonTapped:(id)sender {
    //储存摄入量
    NSMutableDictionary *intakeDict = [[NSMutableDictionary alloc]init];
    BOOL needSaveData = NO;
    for (NSString * NDB_No in [self.foodIntakeDictionary allKeys])
    {
        NSNumber *num = [self.foodIntakeDictionary objectForKey:NDB_No];
        if ([num intValue]>0)
        {
            needSaveData = YES;
            [intakeDict setObject:num forKey:NDB_No];
        }
    }
    if (needSaveData) {
        NSDictionary *userDailyIntake = [[NSDictionary alloc]initWithDictionary:intakeDict];
        [[NSUserDefaults standardUserDefaults]setObject:userDailyIntake forKey:LZUserDailyIntakeKey];
        [[NSUserDefaults  standardUserDefaults]synchronize];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)resetButtonTapped:(id)sender {
    for (NSString * NDB_No in [self.foodIntakeDictionary allKeys])
    {
        [self.foodIntakeDictionary setObject:[NSNumber numberWithInt:0] forKey:NDB_No];
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.listView reloadData];
}
- (void)textFieldDidReturnForIndex:(NSIndexPath*)index andText:(NSString*)foodNumber
{
    //[self.foodIntakeAmountArray replaceObjectAtIndex:index.row withObject:foodNumber];
    NSDictionary *afood = [[self.foodNameArray objectAtIndex:index.section]objectAtIndex:index.row];
    NSString *NDB_No = [afood objectForKey:@"NDB_No"];
    [self.foodIntakeDictionary setObject:[NSNumber numberWithInt:[foodNumber intValue]] forKey:NDB_No];
    NSLog(@"cell section %d , row %d food amount %@",index.section,index.row,foodNumber);
}
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
	tableviewFrame.size.height = self.view.frame.size.height;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)textFieldDidBeginEditingForIndex:(NSIndexPath*)index
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.listView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    });
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}
#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self.searchResultArray removeAllObjects];
    // Return YES to cause the search result table view to be reloaded.
    NSLog(@"%@",searchString);
    for (int i=0; i<[allFood count]; i++)
    {
        NSDictionary *aFood = [allFood objectAtIndex:i];
        NSString *cnName = [aFood objectForKey:@"CnCaption"];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchString];
        if ([pre evaluateWithObject:cnName])
        {
            [self.searchResultArray addObject:aFood];
        }
        
    }
    
   //NSArray *arrayPre=[allFood filteredArrayUsingPredicate: pre];
    //NSLog(@"result %@",arrayPre);
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	/*
     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
	[foodSearchDisplayController.searchResultsTableView setDelegate:self];
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	
    [foodSearchBar resignFirstResponder];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
