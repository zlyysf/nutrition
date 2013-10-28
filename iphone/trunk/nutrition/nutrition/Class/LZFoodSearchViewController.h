//
//  LZFoodSearchViewController.h
//  nutrition
//
//  Created by liu miao on 8/29/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LZFoodSearchViewController : UIViewController<UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *listView;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchResultVC;
@property (strong, nonatomic)NSArray *foodTypeArray;
@property (assign,nonatomic)BOOL isFromOut;
@property (strong,nonatomic)NSMutableArray *searchResultArray;
@property (strong,nonatomic)UIView *admobView;
@end
