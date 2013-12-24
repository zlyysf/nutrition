//
//  NGRecommendFoodView.m
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGRecommendFoodView.h"
#define FoodPicSideWidth 80
#import "LZUtility.h"
@implementation NGRecommendFoodView
@synthesize foodImageView,foodNameLabel,foodAmountLabel,touchButton;
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
        self.foodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FoodPicSideWidth, FoodPicSideWidth)];
        UIImage *foodImage = [UIImage imageWithContentsOfFile:foodPic];
        [foodImageView setImage:foodImage];
        [self addSubview:foodImageView];
        self.foodNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 82, 80, 20)];
        [foodNameLabel setFont:[UIFont systemFontOfSize:14]];
        [foodNameLabel setTextAlignment:UITextAlignmentCenter];
        [foodNameLabel  setBackgroundColor:[UIColor clearColor]];
        [foodNameLabel setTextColor:[UIColor whiteColor]];
        foodNameLabel.text = foodName;
        [self addSubview:foodNameLabel];
        self.foodAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 98, 80, 20)];
        [foodAmountLabel setFont:[UIFont systemFontOfSize:14]];
        [foodAmountLabel setTextAlignment:UITextAlignmentCenter];
        [foodAmountLabel  setBackgroundColor:[UIColor clearColor]];
        [foodAmountLabel setTextColor:[UIColor whiteColor]];
        foodAmountLabel.text = foodAmount;
        [self addSubview:foodAmountLabel];
        
        self.touchButton = [[LZCustomDataButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        UIImage *selectedImage = [LZUtility createImageWithColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f] imageSize:CGSizeMake( frame.size.width, frame.size.height)];
        [touchButton setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
        [self addSubview:touchButton];
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
