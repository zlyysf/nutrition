//
//  LZDiagnosisCell.m
//  nutrition
//
//  Created by liu miao on 8/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDiagnosisCell.h"

@implementation LZDiagnosisCell

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
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    //244,242,236
    [super setHighlighted:highlighted animated:animated];
    [self.sepratorLineView setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
}

@end
