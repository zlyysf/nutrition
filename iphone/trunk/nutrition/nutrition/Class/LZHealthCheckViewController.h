//
//  LZHealthCheckViewController.h
//  nutrition
//
//  Created by liu miao on 9/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZHealthCheckViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSMutableArray *diseaseNamesArray;
@property (strong,nonatomic)NSMutableDictionary *diseasesStateDict;
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSString* checkType;
@property (nonatomic,assign)BOOL backWithNoAnimation;
@property (strong, nonatomic) IBOutlet UIButton *checkItemButton;
@property (strong,nonatomic)NSDictionary *headerDict;
@end
