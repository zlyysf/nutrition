//
//  LZNutrientQueryMainViewController.h
//  nutrition
//
//  Created by Yasofon on 14-6-9.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZNutrientQueryMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>



@property (strong, nonatomic) IBOutlet UITableView *menuListView;
@property (strong, nonatomic) IBOutlet UIView *adBannerView;


@end