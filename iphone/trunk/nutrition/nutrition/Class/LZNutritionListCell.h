//
//  LZNutritionListCell.h
//  nutrition
//
//  Created by liu miao on 8/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZNutritionListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *nutritionNameButton;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong,nonatomic)NSString *nutritionId;
@end
