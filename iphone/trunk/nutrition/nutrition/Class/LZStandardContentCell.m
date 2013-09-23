//
//  LZStandardContentCell.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZStandardContentCell.h"

@implementation LZStandardContentCell

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
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self.sepratorLine setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
}
@end
