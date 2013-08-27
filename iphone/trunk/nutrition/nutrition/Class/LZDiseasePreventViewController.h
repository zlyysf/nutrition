//
//  LZDiseasePreventViewController.h
//  nutrition
//
//  Created by liu miao on 8/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDiseasePreventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic)BOOL isSecondClass;
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSDictionary *diseaseNameDict;
@property (strong,nonatomic) NSArray *diseaseNameLevel1Array;
@property (strong,nonatomic) NSArray *diseaseNameLevel2Array;
@end
