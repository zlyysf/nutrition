//
//  LZRecommendFood.h
//  nutrition
//
//  Created by Yasofon on 13-5-2.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZUtility.h"

@interface LZRecommendFood : NSObject

-(NSArray *) recommendFoodForEnoughNuitrition:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel;

@end












