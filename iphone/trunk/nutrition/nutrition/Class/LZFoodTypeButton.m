//
//  LZFoodTypeButton.m
//  nutrition
//
//  Created by liu miao on 8/29/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodTypeButton.h"

@implementation LZFoodTypeButton
@synthesize typeIcon;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.typeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 13, 26, 26)];
        [self addSubview:self.typeIcon];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//}


@end
