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

-(NSMutableDictionary *) recommendFoodForEnoughNuitrition:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel;

-(NSMutableDictionary *) recommendFoodForEnoughNuitritionWithPreIntake:(NSDictionary*)takenFoodAmountDict sex:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel;

-(void) formatCsv_RecommendFoodForEnoughNuitrition: (NSString *)csvFileName withRecommendResult:(NSDictionary*)recmdDict;
-(NSMutableString *) convert2DArrayToText:(NSArray*)ary2D;

@end












