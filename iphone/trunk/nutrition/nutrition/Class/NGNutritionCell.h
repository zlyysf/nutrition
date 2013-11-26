//
//  NGNutritionCell.h
//  nutrition
//
//  Created by liu miao on 11/25/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZEmptyClassCell.h"

@interface NGNutritionCell : LZEmptyClassCell

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIImageView *sepline1View;
@property (strong, nonatomic) IBOutlet UIImageView *sepline2View;
@property (strong, nonatomic) IBOutlet UILabel *vitaminLabel;
@property (strong, nonatomic) IBOutlet UILabel *mineralLabel;
@end
