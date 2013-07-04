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

+(NSArray*)getCustomNutrients;

-(NSMutableDictionary *) recommendFoodForEnoughNuitritionWithPreIntake:(NSDictionary*)takenFoodAmountDict andUserInfo:(NSDictionary*)userInfo andOptions:(NSDictionary*)options;

-(NSMutableDictionary *) recommendFood_AbstractPerson:(NSDictionary*)params withDecidedFoods:(NSDictionary*)decidedFoodAmountDict andOptions:(NSDictionary*)options;

-(NSMutableDictionary *) recommendFood2WithPreIntake:(NSDictionary*)takenFoodAmountDict andUserInfo:(NSDictionary*)userInfo andParams:(NSDictionary*)params andOptions:(NSDictionary*)options;

-(NSMutableDictionary *) recommendFood2_AbstractPerson:(NSDictionary*)params withDecidedFoods:(NSDictionary*)decidedFoodAmountDict andOptions:(NSDictionary*)options;
//-(NSMutableDictionary *) takenFoodSupplyNutrients_AbstractPerson:(NSDictionary*)params withDecidedFoods:(NSDictionary*)decidedFoodAmountDict;
-(NSMutableDictionary *) takenFoodSupplyNutrients_withUserInfo:(NSDictionary*)userInfo andDecidedFoods:(NSDictionary*)decidedFoodAmountDict andOptions:(NSDictionary*)options;

-(NSMutableDictionary *) recommendFood3_AbstractPerson:(NSDictionary*)params withDecidedFoods:(NSDictionary*)decidedFoodAmountDict andOptions:(NSDictionary*)options;

-(NSArray*) generateData2D_RecommendFoodForEnoughNuitrition:(NSDictionary*)recmdDict;
-(void) formatCsv_RecommendFoodForEnoughNuitrition: (NSString *)csvFileName withRecommendResult:(NSDictionary*)recmdDict;
//-(NSString *) convert2DArrayToCsv: (NSString *)csvFileName withData:(NSArray*)ary2D;
-(NSMutableString *) convert2DArrayToText:(NSArray*)ary2D;

-(NSMutableString*) generateHtml_RecommendFoodForEnoughNuitrition:(NSDictionary*)recmdDict;

-(NSMutableDictionary*)formatRecommendResultForUI:(NSMutableDictionary *)recommendResult;
-(NSMutableDictionary*)formatTakenResultForUI:(NSMutableDictionary *)takenResult;

//-(NSDictionary*) getSomeFoodsToSupplyNutrientsCalculated;
//-(NSMutableDictionary*)tmp_formatFoodsInRecommendUI:(NSMutableDictionary *)foodInfoDict;

-(NSMutableDictionary*)formatFoodsStandardContentForUI;


-(NSMutableDictionary *) recommendFoodBySmallIncrementWithPreIntake:(NSDictionary*)takenFoodAmountDict andUserInfo:(NSDictionary*)userInfo andOptions:(NSDictionary*)options;
-(NSArray*) generateData2D_RecommendFoodBySmallIncrement:(NSDictionary*)recmdDict;
-(NSMutableString*) generateHtml_RecommendFoodBySmallIncrement:(NSDictionary*)recmdDict;

-(NSMutableArray*)formatFoodStandardContentForFood:(NSDictionary *)foodInfo;

-(NSMutableDictionary*)formatRecommendResultBySmallIncrementForUI:(NSMutableDictionary *)recommendResult;

@end












