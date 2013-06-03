//
//  LZFoodNutritionCell.h
//  nutrition
//
//  Created by liu miao on 6/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZProgressView.h"
@interface LZFoodNutritionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet LZProgressView *nutritionProgressView;
@property (strong, nonatomic) IBOutlet UILabel *supplyPercentlabel;
-(void)adjustLabelAccordingToProgress:(float)progress forLabelWidth:(float)labelWith;
@property (strong, nonatomic) IBOutlet UILabel *nutritionNameLabel;

@end
