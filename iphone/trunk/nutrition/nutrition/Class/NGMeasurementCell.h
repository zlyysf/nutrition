//
//  NGMeasurementCell.h
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGMeasurementCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *heatLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UILabel *heartbeatLabel;
@property (strong, nonatomic) IBOutlet UILabel *highpressureLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowpressureLabel;
@property (strong, nonatomic) IBOutlet UILabel *heatUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel *heartbeatUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel *highpressureUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowpressureUnitLabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UITextField *heatTextField;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UITextField *heartbeatTextField;
@property (strong, nonatomic) IBOutlet UITextField *highpressureTextField;
@property (strong, nonatomic) IBOutlet UITextField *lowpressureTextField;
@end
