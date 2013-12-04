//
//  NGRecommendFoodView.m
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGRecommendFoodView.h"
#define FoodPicSideWidth 80
@implementation NGRecommendFoodView

- (id)initWithFrame:(CGRect)frame
           foodName:(NSString *)foodName
            foodPic:(NSString *)foodPic
         foodAmount:(NSString *)foodAmount
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.backgroundColor = [UIColor blackColor];
        UIImageView *foodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FoodPicSideWidth, FoodPicSideWidth)];
        UIImage *foodImage = [UIImage imageWithContentsOfFile:foodPic];
        [foodImageView setImage:foodImage];
        [self addSubview:foodImageView];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 82, 80, 20)];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setTextAlignment:UITextAlignmentCenter];
        [nameLabel  setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        nameLabel.text = foodName;
        [self addSubview:nameLabel];
        UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 98, 80, 20)];
        [amountLabel setFont:[UIFont systemFontOfSize:14]];
        [amountLabel setTextAlignment:UITextAlignmentCenter];
        [amountLabel  setBackgroundColor:[UIColor clearColor]];
        [amountLabel setTextColor:[UIColor whiteColor]];
        amountLabel.text = foodAmount;
        [self addSubview:amountLabel];
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
