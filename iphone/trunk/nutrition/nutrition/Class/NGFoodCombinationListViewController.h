//
//  NGFoodCombinationListViewController.h
//  nutrition
//
//  Created by Yasofon on 14-1-28.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NGFoodCombinationListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mListView;

@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) IBOutlet UIView *mobView;
@property (strong, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (strong, nonatomic) IBOutlet UILabel *emptyTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *emptyBottomLabel;

@property (strong, nonatomic) NSMutableArray *dietArray;
@property (strong,nonatomic)NSNumber *currentEditDietId;
@property (nonatomic,assign)BOOL backWithNoAnimation;
@end