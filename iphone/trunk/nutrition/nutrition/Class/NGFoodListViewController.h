//
//  NGFoodListViewController.h
//  nutrition
//
//  Created by liu miao on 12/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGFoodListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic)NSArray *foodArray;
@property (strong, nonatomic) IBOutlet UIView *adView;

@end
