//
//  NGNutritionInfoViewController.h
//  nutrition
//
//  Created by liu miao on 12/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGNutritionInfoViewController : UIViewController
@property (strong,nonatomic)NSDictionary *nutrientDict;
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong,nonatomic)NSArray*foodArray;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@end
