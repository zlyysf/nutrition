//
//  LZNutritionInfoView.h
//  rgbCalculator
//
//  Created by liu miao on 6/19/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZNutritionInfoView;
@protocol LZNutritionInfoViewDelegate<NSObject>
- (void)infoViewClosed:(LZNutritionInfoView *)infoView;
@end
@interface LZNutritionInfoView : UIView
- (id)initWithFrame:(CGRect)frame
           andColor:(UIColor *)backColor
            andInfo:(NSDictionary *)infoDict
           delegate:(id<LZNutritionInfoViewDelegate>)nutrientDelegate;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,assign)id<LZNutritionInfoViewDelegate>delegate;
@end
