//
//  NGReportHealthScoreCell.h
//  nutrition
//
//  Created by liu miao on 12/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZEmptyClassCell.h"
@interface NGReportHealthScoreCell : LZEmptyClassCell

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *healthScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *fullPercentLabel;
@end
