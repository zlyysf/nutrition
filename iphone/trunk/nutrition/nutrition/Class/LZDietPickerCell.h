//
//  LZDietPickerCell.h
//  nutrition
//
//  Created by liu miao on 8/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDietPickerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *dietNameLabel;
-(void)adjustLabelAccordingToDietName:(NSString *)dietName;
@end
