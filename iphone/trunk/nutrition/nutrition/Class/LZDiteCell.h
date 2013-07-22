//
//  LZDiteCell.h
//  nutrition
//
//  Created by liu miao on 7/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZChangeDietNameButton.h"
@interface LZDiteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (strong, nonatomic) IBOutlet UILabel *dietNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet LZChangeDietNameButton *changeNameButton;
@property (strong, nonatomic) NSDictionary *dietInfo;
@end
