//
//  LZDiagnoseViewController.h
//  nutrition
//
//  Created by liu miao on 8/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
@interface LZDiagnoseViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *outScrollView;
@property (strong, nonatomic) IBOutlet UITableView *listView1;
@property (strong, nonatomic) IBOutlet UITableView *listView2;
@property (strong, nonatomic) IBOutlet UITableView *listView3;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet SMPageControl *smPageControl;
@property (strong, nonatomic) IBOutlet UIImageView *list1BG;
@property (strong, nonatomic) IBOutlet UIImageView *list2BG;
@property (strong, nonatomic) IBOutlet UIImageView *list3BG;
@property (strong, nonatomic) IBOutlet UIImageView *list4BG;
@end
