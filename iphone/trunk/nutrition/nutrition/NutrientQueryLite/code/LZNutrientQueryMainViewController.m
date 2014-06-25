//
//  LZNutrientQueryMainViewController.m
//  nutrition
//
//  Created by Yasofon on 14-6-9.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import "LZNutrientQueryMainViewController.h"
#import "LZMainMenuItemCell.h"

#import "NGFoodCombinationListViewController.h"
#import "NGUerInfoViewController.h"

#import "GADMasterViewController.h"

#import "LZConstants.h"
#import "LZUtility.h"





#define menuItemKey_func @"func"
#define menuItemKey_caption @"caption"

#define menuItem_list @"list"
#define menuItem_userInfo @"userInfo" 



@interface LZNutrientQueryMainViewController ()
{
    NSMutableArray *mMenuItems ;
}

@end

@implementation LZNutrientQueryMainViewController

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
    
    NSString *titleStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
//    NSString *titleStr = NSLocalizedString(@"appNameAtAnotherPlace",@"食物营养查询搭配");
    
    self.title = titleStr;
//    if (![LZUtility isCurrentLanguageChinese]){
//        [[UINavigationBar appearance]setTitleTextAttributes:
//           [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:10],UITextAttributeFont, nil]];
//    }

    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    titleLabel.font = [UIFont boldSystemFontOfSize:30];
//    titleLabel.adjustsFontSizeToFitWidth=YES;//在英文环境下需要，但是由于navigation bar在其他地方有统一设置style，这里导致其style特别
//    if (IOS7_OR_LATER)
//    {
//        titleLabel.textColor = [UIColor colorWithRed:6/255.f green:62/255.f blue:4/255.f alpha:1.0f];
//        titleLabel.tintColor = [UIColor colorWithRed:204/255.f green:255/255.f blue:204/255.f alpha:1.0f];
//    }else{
//    }
////    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textAlignment = UITextAlignmentCenter;
//    titleLabel.text = titleStr;
//    self.navigationItem.titleView = titleLabel;
    

    
    
    mMenuItems = [NSMutableArray array];
    NSMutableDictionary *menuItemDict;
    NSString *caption;
    menuItemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:menuItem_list,menuItemKey_func, nil];
    caption = NSLocalizedString(@"foodNutritionCollocationList",@"食物营养查询搭配清单");
    [menuItemDict setObject:caption forKey:menuItemKey_caption];
    [mMenuItems addObject:menuItemDict];
    
    menuItemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:menuItem_userInfo,menuItemKey_func, nil];
    //caption = NSLocalizedString(@"userParamInfo",@"用户参数信息");
    caption = NSLocalizedString(@"mainpage_menuitem_shezhi",@"设置");
    [menuItemDict setObject:caption forKey:menuItemKey_caption];
    [mMenuItems addObject:menuItemDict];
    
    
    
    [LZGlobalService SetSubViewExternNone:self];
    
//    if (needFee){
//        [self.adBannerView removeFromSuperview];
//        CGRect tvFrame = self.menuListView.frame;
//        //        NSLog(@"self.listView.frame be %f,%f, %f,%f",tvFrame.origin.x,tvFrame.origin.y,tvFrame.size.width,tvFrame.size.height);
//        tvFrame.size.height = tvFrame.size.height+50;
//        self.menuListView.frame = tvFrame;
//    }

    
}

-(void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
//    
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (!needFee){
        GADMasterViewController *shared = [GADMasterViewController singleton];
        [shared resetAdView:self andListView:self.adBannerView];
    }else{
        
    }

}

- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mMenuItems.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZMainMenuItemCell * cell =(LZMainMenuItemCell*)[tableView dequeueReusableCellWithIdentifier:@"LZMainMenuItemCell"];
    
    NSDictionary *menuItemDict = mMenuItems[indexPath.row];
    
    
    [cell.menuItemCaptionLabel setText:menuItemDict[menuItemKey_caption]];
    [cell.menuItemCaptionLabel setHighlighted:false];
    
    return cell;
}



#pragma mark- UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    
    NSDictionary *menuItemDict = mMenuItems[indexPath.row];
    NSString *funcId = menuItemDict[menuItemKey_func];
    if ([funcId isEqualToString:menuItem_list]){
        UIStoryboard *sbd = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
        NGFoodCombinationListViewController *controllerFcl = [sbd instantiateViewControllerWithIdentifier:@"NGFoodCombinationListViewController"];
        [self.navigationController pushViewController:controllerFcl animated:false];
    }else if ([funcId isEqualToString:menuItem_userInfo]){
        UIStoryboard *sbd = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
        NGUerInfoViewController *controllerUi = [sbd instantiateViewControllerWithIdentifier:@"NGUerInfoViewController"];
        [self.navigationController pushViewController:controllerUi animated:false];
    }
}




@end


















