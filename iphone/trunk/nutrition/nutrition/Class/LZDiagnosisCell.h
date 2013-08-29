//
//  LZDiagnosisCell.h
//  nutrition
//
//  Created by liu miao on 8/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDiagnosisCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *diseaseNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkImageView;
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UIView *sepratorLineView;
@end
