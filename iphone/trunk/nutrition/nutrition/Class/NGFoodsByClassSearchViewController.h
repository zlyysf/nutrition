//
//  NGFoodsByClassSearchViewController.h
//  nutrition
//
//  Created by Yasofon on 14-2-8.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGFoodCombinationEditViewController.h"

@interface NGFoodsByClassSearchViewController : UIViewController<UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *listView;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchResultVC;
@property (strong, nonatomic)NSArray *foodTypeArray;
@property (assign,nonatomic)BOOL isFromOut;
@property (strong,nonatomic)NSMutableArray *searchResultArray;
@property (strong,nonatomic)UIView *admobView;

@property (assign,nonatomic)id<NGFoodCombinationEditViewControllerDelegate> editDelegate;

@end