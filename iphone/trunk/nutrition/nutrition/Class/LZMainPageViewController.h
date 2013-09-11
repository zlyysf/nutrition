//
//  LZMainPageViewController.h
//  nutrition
//
//  Created by liu miao on 8/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZMainPageViewController : UIViewController

@property (strong,nonatomic) NSArray *menuArray;
@property (strong, nonatomic) IBOutlet UIScrollView *listView;
@property (strong,nonatomic)UIView *admobView;
@end
