//
//  LZDailyIntakeViewController.h
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDataAccess.h"
@interface LZDailyIntakeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong , nonatomic)NSMutableArray *foodNameArray;
@property (strong, nonatomic)NSMutableDictionary *foodIntakeDictionary;
@property (strong, nonatomic)NSMutableArray *foodTypeArray;
@property (strong, nonatomic)NSMutableArray *searchResultArray;
@property (strong, nonatomic)NSArray *allFood;
@property (strong, nonatomic)UISearchBar *foodSearchBar;
@property (strong, nonatomic)UISearchDisplayController *foodSearchDisplayController;
@end
