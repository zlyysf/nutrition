//
//  LZFoodCell.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LZRecommendFoodCellDelegate<NSObject>
- (void)userSelectedCellForIndexPath :(NSIndexPath*)indexPath;
@end
@interface LZRecommendFoodCell : UITableViewCell
@property (strong,nonatomic)NSIndexPath *cellIndexPath;
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodWeightlabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (assign,nonatomic)id<LZRecommendFoodCellDelegate>delegate;
@end
