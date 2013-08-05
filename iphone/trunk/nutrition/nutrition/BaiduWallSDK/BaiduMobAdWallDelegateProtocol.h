//
//  BaiduMobAdWallDelegateProtocol.h
//  BaiduMobAdWallSdkSample
//
//  Created by shao bo on 13-4-9.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

///---------------------------------------------------------------------------------------
/// @name 协议板块
///---------------------------------------------------------------------------------------

@class BaiduMobAdWall;
/**
 *  广告sdk委托协议
 */
@protocol BaiduMobAdWallDelegate<NSObject>

@required
/**
 *  应用在mounion.baidu.com上的id
 */
- (NSString *)publisherId;

/**
 *  应用在mounion.baidu.com上的计费名
 */
- (NSString*) appSpec;



@optional
/**
 *  启动位置信息
 */
-(BOOL) enableLocation;

@optional
/**
 *  获取到积分
 */
-(void) didGetPoints: (NSInteger) points;

@optional
/**
 *  积分墙页面关闭
 */
- (void)offerWallDidClosed;


@end
