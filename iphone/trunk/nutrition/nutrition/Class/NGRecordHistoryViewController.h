//
//  NGRecordHistoryViewController.h
//  nutrition
//
//  Created by liu miao on 11/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NGCycleScrollView.h"
@interface NGRecordHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView1;
@property (strong, nonatomic) IBOutlet UITableView *listView2;
@property (strong, nonatomic) IBOutlet UITableView *listView3;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@end
