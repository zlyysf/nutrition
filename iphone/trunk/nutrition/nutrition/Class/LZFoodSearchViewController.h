//
//  LZFoodSearchViewController.h
//  nutrition
//
//  Created by liu miao on 8/29/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZFoodSearchViewController : UIViewController<UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchResultVC;
@property (strong, nonatomic)NSMutableArray *foodTypeArray;
@property (strong, nonatomic)NSArray *allFood;
@property (strong , nonatomic)NSMutableArray *foodNameArray;
@end
