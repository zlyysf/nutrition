//
//  LZRichNutritionViewController.h
//  nutrition
//
//  Created by liu miao on 8/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZRichNutritionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong,nonatomic)NSArray *foodArray;
//@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic)NSString *nutrientTitle;
@property (strong,nonatomic)NSDictionary *nutrientDict;
@end
