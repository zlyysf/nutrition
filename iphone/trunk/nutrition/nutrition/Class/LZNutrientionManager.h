//
//  LZNutrientionManager.h
//  rgbCalculator
//
//  Created by liu miao on 6/19/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZNutritionInfoView.h"
@interface LZNutrientionManager : NSObject<LZNutritionInfoViewDelegate>
+(LZNutrientionManager*)SharedInstance;
- (void)showNutrientInfo:(NSString *)nutrientId;
@end
