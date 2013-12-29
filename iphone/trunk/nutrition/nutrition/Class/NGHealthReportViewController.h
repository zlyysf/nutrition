//
//  NGHealthReportViewController.h
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGHealthReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic)NSDictionary *userInputValueDict;
@property (strong, nonatomic) NSArray *userSelectedSymptom;
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) NSArray *symptomsByTypeArray;
@property (assign,nonatomic)BOOL isOnlyDisplay;
@end
