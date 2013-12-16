//
//  LZKeychainManager.h
//  nutrition
//
//  Created by Chenglei Shen on 12/16/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZKeychainManager : NSObject
+(void)saveObject:(id)data withService:(NSString *)service;
+(id)loadObjectWithService:(NSString *)service;
+(void)removeService:(NSString *)service;
@end