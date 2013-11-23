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
           foodInfo:(NSDictionary *)foodInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.backgroundColor = [UIColor blackColor];
        NSString *foodPic = [foodInfo objectForKey:@"foodpic"];
        UIImageView *foodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FoodPicSideWidth, FoodPicSideWidth)];
        [foodImageView setImage:[UIImage imageNamed:foodPic]];
        [self addSubview:foodImageView];
        NSString *foodName = [foodInfo objectForKey:@"foodname"];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 80, 20)];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setTextAlignment:UITextAlignmentCenter];
        [nameLabel  setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        nameLabel.text = foodName;
        [self addSubview:nameLabel];
        NSString *foodAmount = [foodInfo objectForKey:@"foodamount"];
        UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 80, 20)];
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
