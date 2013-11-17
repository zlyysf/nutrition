//
//  LZGlobalService.h
//  nutrition
//
//  Created by liu miao on 11/7/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface LZGlobalService : NSObject
+(void)SetSubViewExternNone:(UIViewController *)viewController;
@end
