//
//  LZNutritionSupplyCell.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZProgressView.h"



//@interface NGNutritionSupplyCell : UITableViewCell
//@property (strong, nonatomic) IBOutlet LZProgressView *nutritionProgressView;
//@property (strong, nonatomic) IBOutlet UILabel *nutrientSupplyLabel;
//@property (strong, nonatomic) IBOutlet UIButton *nameButton;
//@property (strong,nonatomic)NSString *nutrientId;
//@end

@interface NGNutritionSupplyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet LZProgressView *nutritionProgressView;
@property (strong, nonatomic) IBOutlet UILabel *nutrientSupplyLabel;
@property (strong, nonatomic) IBOutlet UILabel *nutritionNameLabel;

@property (weak, nonatomic) IBOutlet UIView *addSignImageView;



@property (strong,nonatomic)NSString *nutrientId;

@property (assign,nonatomic)BOOL enableHighlighted;

//有个bug解决不了，改为cell中不包含逻辑，只相当于一个struct，用不同的在storyboard的控件对应同一个class试试
//@property (assign,nonatomic)BOOL enableAdd;
//-(void)adjustViewsAccordingFlags;



@end