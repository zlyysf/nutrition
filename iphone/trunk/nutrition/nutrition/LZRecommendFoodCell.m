//
//  LZFoodCell.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFoodCell.h"

@implementation LZRecommendFoodCell
@synthesize delegate,cellIndexPath;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)selectedAction:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(userSelectedCellForIndexPath:)])
//    {
//        [self.delegate userSelectedCellForIndexPath:self.cellIndexPath];
//    }

    [self performSelector:@selector(sendSelectedInformation) withObject:nil afterDelay:0.1];
}
- (void)sendSelectedInformation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userSelectedCellForIndexPath:)])
    {
        [self.delegate userSelectedCellForIndexPath:self.cellIndexPath];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
