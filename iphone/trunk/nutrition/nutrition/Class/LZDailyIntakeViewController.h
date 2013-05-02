//
//  LZDailyIntakeViewController.h
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDailyIntakeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong , nonatomic)NSMutableArray *foodNameArray;
@property (strong, nonatomic)NSMutableArray *foodIntakeAmountArray;
@end
