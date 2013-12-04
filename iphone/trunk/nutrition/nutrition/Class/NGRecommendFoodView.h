//
//  NGRecommendFoodView.h
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGRecommendFoodView : UIView
- (id)initWithFrame:(CGRect)frame
           foodName:(NSString *)foodName
            foodPic:(NSString *)foodPic
         foodAmount:(NSString *)foodAmount;
@end
