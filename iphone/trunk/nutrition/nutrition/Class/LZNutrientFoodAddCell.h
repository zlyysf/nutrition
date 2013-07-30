//
//  LZNutrientFoodAddCell.h
//  nutrition
//
//  Created by liu miao on 6/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodCell.h"

@interface LZNutrientFoodAddCell : LZFoodCell
@property (strong, nonatomic) IBOutlet UILabel *recommendAmountLabel;
- (void)centeredFoodNameButton:(BOOL)centered;
@end
