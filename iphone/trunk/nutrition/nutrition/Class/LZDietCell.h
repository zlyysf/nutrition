//
//  LZDiteCell.h
//  nutrition
//
//  Created by liu miao on 7/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZCustomDataButton.h"
@interface LZDietCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *dietNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet LZCustomDataButton *changeNameButton;
@property (strong, nonatomic) NSDictionary *dietInfo;
-(void)adjustLabelAccordingToDietName:(NSString *)dietName;
@end
