//
//  LZMainMenuButton.m
//  nutrition
//
//  Created by liu miao on 9/11/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZMainMenuButton.h"

@implementation LZMainMenuButton
@synthesize itemTitleLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.itemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, frame.size.height-28-7, frame.size.width-2, 28)];
        [self.itemTitleLabel setTextColor:[UIColor whiteColor]];
        [self.itemTitleLabel setFont:[UIFont boldSystemFontOfSize:23]];
        [self.itemTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.itemTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:itemTitleLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
