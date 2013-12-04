//
//  NGReportNutritonFoodCell.h
//  nutrition
//
//  Created by liu miao on 12/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZCustomDataButton.h"
@protocol NGReportNutritonFoodCellDelegate<NSObject>
-(void)foodClickedForIndex:(NSIndexPath*)index andTag:(int)tag;
@end
@interface NGReportNutritonFoodCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *nutritionHeaderlabel;
@property (strong, nonatomic) IBOutlet UILabel *foodHeaderLabel;
@property (nonatomic, assign) id<NGReportNutritonFoodCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet LZCustomDataButton *nutritionNameButton;
@property (strong,nonatomic)NSIndexPath *cellIndex;
@property (strong, nonatomic) IBOutlet UIScrollView *foodScrollView;
-(void)setFoods:(NSArray*)foodArray isChinese:(BOOL)isChinese;
@end
