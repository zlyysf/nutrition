//
//  LZFoodCell.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZEditFoodAmountButton.h"
@interface LZRecommendFoodCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodWeightlabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) NSString * cellFoodId;
@property (strong, nonatomic) IBOutlet UILabel *foodUnitLabel;
@property (strong, nonatomic) IBOutlet UIImageView *recommendSignImageView;
@property (strong, nonatomic) IBOutlet LZEditFoodAmountButton *editFoodButton;
@property (strong, nonatomic) IBOutlet UILabel *foodTotalUnitLabel;

@end
