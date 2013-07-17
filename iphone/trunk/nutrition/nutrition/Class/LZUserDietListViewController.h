//
//  LZUserDietListViewController.h
//  nutrition
//
//  Created by liu miao on 7/15/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZUserDietListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) IBOutlet UIView *mobView;
@property (strong, nonatomic) NSMutableArray *dietArray;
@end
