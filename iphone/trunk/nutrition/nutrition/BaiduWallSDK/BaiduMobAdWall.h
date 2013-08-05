//
//  BaiduMobAdWall.h
//  BaiduMobAdWallSdk
//
//  Created by shao bo on 13-4-9.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdWallDelegateProtocol.h"

@interface BaiduMobAdWall : NSObject{
    @private
    id<BaiduMobAdWallDelegate> _delegate;
    

}

///---------------------------------------------------------------------------------------
/// @name 属性
///---------------------------------------------------------------------------------------

/**
 *  委托对象
 */
@property (nonatomic ,assign) id<BaiduMobAdWallDelegate>  delegate;

/**
 *  SDK版本
 */
@property (nonatomic, readonly) NSString* Version;


/**
 *  展示积分墙
 */
- (void)showOffers;

/**
 * 获取总积分
 */
- (NSInteger)getPoints;

/**
 * 消费积分
 */
- (BOOL)spendPoints:(NSInteger) points;

/**
 * 赚取积分
 */
- (void)earnPoints:(NSInteger) points;

@end
