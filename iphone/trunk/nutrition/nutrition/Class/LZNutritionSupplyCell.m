//
//  LZNutritionSupplyCell.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutritionSupplyCell.h"
#import "LZNutrientionManager.h"
@implementation LZNutritionSupplyCell
@synthesize nutrientId;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)nameButtonTapped:(id)sender {
    [[LZNutrientionManager SharedInstance]showNutrientInfo:self.nutrientId];
}

@end
