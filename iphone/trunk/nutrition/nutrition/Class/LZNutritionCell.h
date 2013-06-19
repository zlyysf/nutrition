//
//  LZNutritionCell.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZProgressView.h"
@interface LZNutritionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet LZProgressView *nutritionProgressView;
@property (strong, nonatomic) IBOutlet UILabel *supplyPercentlabel;
-(void)adjustLabelAccordingToProgress:(float)progress forLabelWidth:(float)labelWith;
@property (strong, nonatomic) IBOutlet UIButton *nameButton;
@property (strong, nonatomic)NSString *nutrientId;
@end
