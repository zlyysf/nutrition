//
//  LZHealthCheckViewController.h
//  nutrition
//
//  Created by liu miao on 9/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZHealthCheckViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSArray *departmentNamesArray;
@property (strong,nonatomic)NSMutableDictionary *diseasesStateDict;
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@end
