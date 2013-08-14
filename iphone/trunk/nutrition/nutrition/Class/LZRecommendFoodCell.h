//
//  LZFoodCell.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZRecommendFoodCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) NSString * cellFoodId;
@property (strong, nonatomic) IBOutlet UILabel *foodUnitLabel;
@property (strong, nonatomic) IBOutlet UIImageView *recommendSignImageView;

@end
