//
//  NGReportBMICell.h
//  nutrition
//
//  Created by liu miao on 12/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZEmptyClassCell.h"
@interface NGReportBMICell : LZEmptyClassCell
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *bmiValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *level1Label;
@property (strong, nonatomic) IBOutlet UILabel *level3Label;
@property (strong, nonatomic) IBOutlet UIView *levelView;
@property (strong, nonatomic) IBOutlet UILabel *level2Label;
@property (strong, nonatomic) IBOutlet UILabel *level4Label;

-(void)setBMIValue:(double)bmiValue;
@end
