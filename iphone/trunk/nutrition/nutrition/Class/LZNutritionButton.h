//
//  LZNutritionButton.h
//  nutrition
//
//  Created by liu miao on 10/15/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZNutritionButton : UIButton
@property (nonatomic,strong)id customData;
- (id)initWithFrame:(CGRect)frame
               info:(NSDictionary *)info
              image:(UIImage *)backImage;
@end
