//
//  LZUtilityParse.h
//  nutrition
//
//  Created by Yasofon on 14-2-17.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LZConstants.h"
#import <Parse/Parse.h>

@interface LZUtilityParse : NSObject



+(void)Test_saveParseObj;
+(void)Test_getParseObj;
+(void)Test_updateParseObj;

+(void) saveParseObjectInfo_CurrentUserRecordSymptom_withParseObjectId: (NSString*) parseObjId andDayLocal:(int) dayLocal;
+(PFObject*) getToSaveParseObject_UserRecordSymptom_withDayLocal:(int) dayLocal andUpdateTimeUTC:(NSDate*) updateTimeUTC andInputNameValuePairsData:(NSDictionary*) inputNameValuePairsData andNote:(NSString*) Note andCalculateNameValuePairsData:(NSDictionary*) calculateNameValuePairsData;
//+(PFQuery*) getParseQueryByCurrentDeviceForUserRecordSymptom_withDayLocal:(int)dayLocal;
//+(PFQuery*) getParseQueryByCurrentDeviceForUserRecordSymptom;

+(void) deleteParseObject_FoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId;
+(void) saveParseObject_FoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId;
+(void) syncRemoteDataToLocal_withJustCallback:(JustCallbackBlock) justCallback;


@end
