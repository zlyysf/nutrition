//
//  NGDiagnoseViewController.h
//  nutrition
//
//  Created by liu miao on 11/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGDiagnoseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSArray *symptomTypeIdArray;
@property (strong,nonatomic)NSMutableDictionary *symptomRowsDict;
@property (strong,nonatomic)NSMutableDictionary *symptomStateDict;
@property (strong,nonatomic)NSMutableArray *userSelectedSymptom;
@end
