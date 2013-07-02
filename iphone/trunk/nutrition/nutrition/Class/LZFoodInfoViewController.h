//
//  LZFoodInfoViewController.h
//  nutrition
//
//  Created by liu miao on 7/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZFoodInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) IBOutlet UIView *admobView;
@property (strong,nonatomic)NSArray *nutrientStandardArray;
@end
