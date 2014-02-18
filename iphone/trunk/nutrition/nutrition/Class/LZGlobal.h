//
//  LZGlobal.h
//  nutrition
//
//  Created by Yasofon on 14-2-7.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZGlobal : NSObject

+(LZGlobal*)SharedInstance;

//@property (strong,nonatomic)NSDictionary *m_nutrientInfoDict2Level;
-(NSDictionary *)getAllNutrient2LevelDict;
-(NSDictionary *)getAllFood2LevelDict;


@end
