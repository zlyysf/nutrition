//
//  NGNoteCell.h
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZEmptyClassCell.h"
@interface NGNoteCell : LZEmptyClassCell
@property (strong, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@end
