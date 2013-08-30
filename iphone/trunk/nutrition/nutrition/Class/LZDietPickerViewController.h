//
//  LZDietPickerViewController.h
//  nutrition
//
//  Created by liu miao on 8/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDietPickerViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) NSMutableArray *dietArray;
@property (strong,nonatomic)NSDictionary *foodDict;
//@property (strong,nonatomic)NSArray *recommendNutritionArray;
@end
