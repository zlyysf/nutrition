//
//  NGFoodNutritionCell.h
//  nutrition
//
//  Created by liu miao on 12/10/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZProgressView.h"
@interface NGFoodNutritionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nutritionNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *supplyPercentlabel;
@property (strong, nonatomic) IBOutlet LZProgressView *supplyProgressView;
@end
