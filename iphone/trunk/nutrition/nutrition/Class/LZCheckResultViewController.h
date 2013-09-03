//
//  LZCheckResultViewController.h
//  nutrition
//
//  Created by liu miao on 9/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZCheckResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *userPreferArray;
@property (nonatomic,strong)NSString *userSelectedNames;
@property (strong, nonatomic) IBOutlet UITableView *listView;
@end
