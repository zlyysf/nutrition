//
//  NGReportNutritonFoodCell.h
//  nutrition
//
//  Created by liu miao on 12/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGReportNutritonFoodCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *nutritionHeaderlabel;
@property (strong, nonatomic) IBOutlet UILabel *foodHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *nutritonLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *foodScrollView;
@end
