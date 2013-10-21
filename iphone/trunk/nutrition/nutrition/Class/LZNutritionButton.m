//
//  LZNutritionButton.m
//  nutrition
//
//  Created by liu miao on 10/15/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutritionButton.h"

@implementation LZNutritionButton
@synthesize customData;
- (id)initWithFrame:(CGRect)frame
               info:(NSDictionary *)info
              image:(UIImage *)backImage
          isChinese:(BOOL)isChinese
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString *chinesePart = [info objectForKey:@"ChinesePart"];
        NSString *englishPart = [info objectForKey:@"EnglishPart"];
        NSString *label1Content;
        NSString *label2Content;
        BOOL needTwoLabel = NO;
        if ([chinesePart length])
        {
            if ([englishPart length])//维生素 A
            {
                label1Content = chinesePart;
                label2Content = englishPart;
                needTwoLabel = YES;
            }
            else //钙
            {
                label1Content = chinesePart;
                needTwoLabel = NO;
            }
        }
        else
        {
            NSArray *array = [englishPart componentsSeparatedByString:@" "];
            if([array count] ==2)//Vitamin A
            {
                label1Content = [array objectAtIndex:0];
                label2Content = [array objectAtIndex:1];
                needTwoLabel = YES;
            }
            else//Calcium
            {
                label1Content = englishPart;
                needTwoLabel = NO;
            }
        }
        if (needTwoLabel)
        {
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
            [label1 setTextColor:[UIColor whiteColor]];
            [label1 setFont:[UIFont boldSystemFontOfSize:18]];
            [label1 setBackgroundColor:[UIColor clearColor]];
            [label1 setText:label1Content];
            [label1 setTextAlignment:UITextAlignmentCenter];
            [self addSubview:label1];
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, frame.size.width, frame.size.height-40 ) ];
            [label2 setFont:[UIFont boldSystemFontOfSize:36]];
            [label2 setTextColor:[UIColor whiteColor]];
            [label2 setBackgroundColor:[UIColor clearColor]];
            [label2 setText:label2Content];
            [label2 setTextAlignment:UITextAlignmentCenter];
            [self addSubview:label2];
        }
        else
        {
            float fontSize;
            if (isChinese)
            {
                fontSize = 30;
            }
            else
            {
                fontSize = 23;
            }
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [label1 setTextColor:[UIColor whiteColor]];
            label1.numberOfLines = 0;
            [label1 setFont:[UIFont boldSystemFontOfSize:fontSize]];
            [label1 setBackgroundColor:[UIColor clearColor]];
            [label1 setText:label1Content];
            [label1 setTextAlignment:UITextAlignmentCenter];
            [self addSubview:label1];
        }
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
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
