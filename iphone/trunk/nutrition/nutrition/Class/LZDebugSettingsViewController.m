//
//  LZDebugSettingsViewController.m
//  nutrition
//
//  Created by liu miao on 8/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDebugSettingsViewController.h"
#import "LZConstants.h"
@interface LZDebugSettingsViewController ()

@end

@implementation LZDebugSettingsViewController
@synthesize debugSettingsArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *debugSettingsDict = [[NSUserDefaults standardUserDefaults]objectForKey:KeyDebugSettingsDict];
    self.debugSettingsArray = [[NSMutableArray alloc]init];
    if (debugSettingsDict != nil)
    {
        for (NSString *key in [debugSettingsDict allKeys])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[debugSettingsDict objectForKey:key],key, nil];
            [self.debugSettingsArray addObject:dict];
        }
    }
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = saveItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)cancelButtonTapped
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void)saveButtonTapped
{
    NSMutableDictionary *newSettingsDict = [[NSMutableDictionary alloc]init];
    for (NSDictionary *aSettingDict in self.debugSettingsArray)
    {
        NSString *key = [[aSettingDict allKeys]objectAtIndex:0];
        NSNumber *value = [aSettingDict objectForKey:key];
        [newSettingsDict setObject:value forKey:key];
    }
    [[NSUserDefaults standardUserDefaults]setObject:newSettingsDict forKey:KeyDebugSettingsDict];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.debugSettingsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DebugSettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *aSettingDict = [self.debugSettingsArray objectAtIndex:indexPath.row];
    NSString *key = [[aSettingDict allKeys]objectAtIndex:0];
    cell.textLabel.text = key;
    for (UIView *subView in cell.contentView.subviews)
    {
        if([subView isMemberOfClass:[UISwitch class]])
        {
            [subView removeFromSuperview];
        }
    }
    UISwitch *settingSwitch = [[UISwitch alloc]init];
    [cell.contentView addSubview:settingSwitch];
    CGRect switchFrame = settingSwitch.frame;
    switchFrame.origin.x = cell.contentView.frame.size.width - switchFrame.size.width-20;
    switchFrame.origin.y = (cell.contentView.frame.size.height - switchFrame.size.height)/2;
    settingSwitch.frame = switchFrame;
    NSNumber *value = [aSettingDict objectForKey:key];
    
    [settingSwitch setOn:[value boolValue]];
    settingSwitch.tag = indexPath.row;
    [settingSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Configure the cell...
    
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)switchValueChanged:(UISwitch*)sender
{
    int tag = sender.tag;
    BOOL isOn = sender.isOn;
    NSMutableDictionary *aSettingDict = [self.debugSettingsArray objectAtIndex:tag];
    NSString *key = [[aSettingDict allKeys]objectAtIndex:0];
    [aSettingDict setObject:[NSNumber numberWithBool:isOn] forKey:key];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

@end
