//
//  LZUtilityParse.m
//  nutrition
//
//  Created by Yasofon on 14-2-17.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import "LZUtilityParse.h"
#import "LZUtility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import "LZDataAccess.h"

@implementation LZUtilityParse


+(PFObject*) newParseObjectByCurrentDeviceForUserRecord_withFileContent:(NSString*) fileContent
{
    NSLog(@"newParseObjectByCurrentDeviceForUserRecord_withFileContent enter");
    NSString *uniqueDeviceId = [LZUtility uniqueDeviceId];
    
    NSData * fileData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
    PFFile *pFile = [PFFile fileWithName:@"UserRecord.txt" data:fileData];
    
	// Stitch together a postObject and send this async to Parse
	PFObject *newPFObj = [PFObject objectWithClassName:ParseObject_UserRecord];
	[newPFObj setObject:uniqueDeviceId forKey:ParseObjectKey_UserRecord_deviceId];
    [newPFObj setObject:pFile forKey:ParseObjectKey_UserRecord_attachFile];
    
    return newPFObj;
}

+(void) updateParseObject_UserRecord_WithParseObject:(PFObject*) parseObjUserRecord andFileContent:(NSString*) fileContent
{
    NSLog(@"updateParseObject_UserRecord_WithParseObject enter");
    NSData * fileData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
    PFFile *pFile = [PFFile fileWithName:@"UserRecord.txt" data:fileData];
    [parseObjUserRecord setObject:pFile forKey:ParseObjectKey_UserRecord_attachFile];
}


+(PFQuery*) getParseQueryByCurrentDeviceForUserRecord
{
    NSLog(@"getParseQueryByCurrentDeviceForUserRecord enter");
    NSString *uniqueDeviceId = [LZUtility uniqueDeviceId];
    NSLog(@"uniqueDeviceId=%@",uniqueDeviceId);
    PFQuery *pQuery = [PFQuery queryWithClassName:ParseObject_UserRecord];
    [pQuery whereKey:ParseObjectKey_UserRecord_deviceId equalTo:uniqueDeviceId];
    return pQuery;
}

+(void)Test_saveParseObj
{
    NSString *s1 = @"333中共中央关于全面深化改革若干重大问题的决定》明确考试招生制度改革的顶层设计，是我国教育考试招生制度系统性综合性最强的一次改革，将显著扭转应试教育倾向，为亿万学生提供多样化的学习选择和成长途径，构建衔接沟通各级各类教育、认可多种学习成果的人才成长“立交桥”。";
    PFObject* parseObjUserRecord = [self newParseObjectByCurrentDeviceForUserRecord_withFileContent:s1];
    [parseObjUserRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSMutableString *msg = [NSMutableString string];
        if (succeeded){
            [msg appendFormat:@"PFObject.saveInBackgroundWithBlock OK"];
        }else{
            [msg appendFormat:@"PFObject.saveInBackgroundWithBlock ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
        }
	}];
}

PFObject *g_parseObjUserRecord=nil;
+(void)Test_getParseObj
{
    PFQuery *pQuery = [self getParseQueryByCurrentDeviceForUserRecord];
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableString *msg = [NSMutableString string];
        if (!error) {
            [msg appendFormat:@"PFQuery.findObjectsInBackgroundWithBlock OK, objects cnt=%d",objects.count];
            if (objects.count > 0){
                PFObject *parseObjUserRecord = objects[0];
                g_parseObjUserRecord = parseObjUserRecord;
                [msg appendFormat:@" item0.objectId=%@",parseObjUserRecord.objectId];
                PFFile *pFile = [parseObjUserRecord objectForKey:ParseObjectKey_UserRecord_attachFile];
                if (pFile != nil){
                    [msg appendFormat:@" and have file"];
                    
                    [pFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        NSMutableString *msg = [NSMutableString string];
                        if (error){
                            [msg appendFormat:@"PFFile.getDataInBackgroundWithBlock ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
                        }else{
                            NSString* strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            [msg appendFormat:@"PFFile.getDataInBackgroundWithBlock OK. data=%@",strData];
                        }
                    }];
                }else{
                    [msg appendFormat:@" but file is null"];
                }
            }
        }else{
            [msg appendFormat:@"pQuery findObjectsInBackgroundWithBlock ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
        }
    }];
}

+(void)Test_updateParseObj
{
    PFObject *parseObjUserRecord = g_parseObjUserRecord;
    if (parseObjUserRecord==nil){
        return;
    }
    NSString *s1 = @"333汇集国内外重大时事、热点聚焦、包括国内、国际、军事、财经各类重大突发新闻，超大资讯量二十四小时滚动更新（150-180条/月），让您第一时间得到最新消息。";
    [self updateParseObject_UserRecord_WithParseObject:parseObjUserRecord andFileContent:s1];
    
    [parseObjUserRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSMutableString *msg = [NSMutableString string];
        if (succeeded){
            [msg appendFormat:@"PFObject.saveInBackgroundWithBlock OK"];
        }else{
            [msg appendFormat:@"PFObject.saveInBackgroundWithBlock ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
        }
	}];
}

+(void) saveParseObjectInfo_CurrentUserRecordSymptom_withParseObjectId: (NSString*) parseObjId andDayLocal:(int) dayLocal
{
    [[NSUserDefaults standardUserDefaults]setObject:parseObjId forKey:ParseObjectKey_objectId];
    [[NSUserDefaults standardUserDefaults]setInteger:dayLocal forKey:COLUMN_NAME_DayLocal];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(PFObject*) getToSaveParseObject_UserRecordSymptom_withDayLocal:(int) dayLocal andUpdateTimeUTC:(NSDate*) updateTimeUTC andInputNameValuePairsData:(NSDictionary*) inputNameValuePairsData andNote:(NSString*) Note andCalculateNameValuePairsData:(NSDictionary*) calculateNameValuePairsData
{
    NSLog(@"getToSaveParseObject_UserRecordSymptom_withDayLocal enter");
    NSString* stored_parseObjId = [[NSUserDefaults standardUserDefaults] stringForKey:ParseObjectKey_objectId];
    NSInteger stored_dayLocal = [[NSUserDefaults standardUserDefaults] integerForKey:COLUMN_NAME_DayLocal];
    
    NSString* parseObjIdValid = nil;
    if (stored_parseObjId != nil && stored_parseObjId.length>0 && stored_dayLocal>0){
        if (stored_dayLocal == dayLocal){
            parseObjIdValid = stored_parseObjId;//stored value is valid
        }else{
            //				StoredConfigTool.saveParseObjectInfo_CurrentUserRecordSymptom(ctx,null);//stored value is old , clear
        }
    }
    
    PFObject* parseObj = nil;
    if (parseObjIdValid==nil)
        parseObj = [PFObject objectWithClassName:ParseObject_UserRecordSymptom];
    else
        parseObj = [PFObject objectWithoutDataWithClassName:ParseObject_UserRecordSymptom objectId:parseObjIdValid];
    
    NSString *uniqueDeviceId = [LZUtility uniqueDeviceId];
    [parseObj setObject:uniqueDeviceId forKey:ParseObjectKey_UserRecord_deviceId];
    
    [parseObj setObject:[NSNumber numberWithInt:dayLocal] forKey:COLUMN_NAME_DayLocal];
    
    long long llUpdateTimeUTC = [LZUtility getMillisecond:updateTimeUTC];
    [parseObj setObject:[NSNumber numberWithLongLong:llUpdateTimeUTC] forKey:COLUMN_NAME_UpdateTimeUTC];
    
    CJSONSerializer * CJSONSerializer1 = [CJSONSerializer serializer];
    NSError *error = NULL;
    if (inputNameValuePairsData!=nil){
        NSData *jsonData_inputNameValuePairs = [CJSONSerializer1 serializeObject:inputNameValuePairsData error:&error];
        assert(error == NULL);
        NSString *jsonString_inputNameValuePairs = [[NSString alloc] initWithData:jsonData_inputNameValuePairs encoding:NSUTF8StringEncoding];
        [parseObj setObject:jsonString_inputNameValuePairs forKey:COLUMN_NAME_inputNameValuePairs];
    }
    
    if(Note != nil){
        [parseObj setObject:Note forKey:COLUMN_NAME_Note];
    }
    
    if (calculateNameValuePairsData!=nil){
        NSData *jsonData_calculateNameValuePairs = [CJSONSerializer1 serializeObject:calculateNameValuePairsData error:&error];
        assert(error == NULL);
        NSString *jsonString_calculateNameValuePairs = [[NSString alloc] initWithData:jsonData_calculateNameValuePairs encoding:NSUTF8StringEncoding];
        [parseObj setObject:jsonString_calculateNameValuePairs forKey:COLUMN_NAME_calculateNameValuePairs];
    }
    
    return parseObj;
}


+(PFQuery*) getParseQueryByCurrentDeviceForUserRecordSymptom_withDayLocal:(int)dayLocal
{
    NSLog(@"getParseQueryByCurrentDeviceForUserRecordSymptom_withDayLocal enter");
    NSString *uniqueDeviceId = [LZUtility uniqueDeviceId];
    PFQuery *pQuery = [PFQuery queryWithClassName:ParseObject_UserRecordSymptom];
    [pQuery whereKey:ParseObjectKey_UserRecordSymptom_deviceId equalTo:uniqueDeviceId];
    [pQuery whereKey:COLUMN_NAME_DayLocal equalTo:[NSNumber numberWithInt:dayLocal ]];
    return pQuery;
}

+(PFQuery*) getParseQueryByCurrentDeviceForUserRecordSymptom
{
    NSLog(@"getParseQueryByCurrentDeviceForUserRecordSymptom enter");
    NSString *uniqueDeviceId = [LZUtility uniqueDeviceId];
    NSLog(@"uniqueDeviceId=%@",uniqueDeviceId);
    PFQuery *pQuery = [PFQuery queryWithClassName:ParseObject_UserRecordSymptom];
    [pQuery whereKey:ParseObjectKey_UserRecordSymptom_deviceId equalTo:uniqueDeviceId];
    [pQuery addAscendingOrder:COLUMN_NAME_DayLocal];
    return pQuery;
}


+(NSMutableDictionary*) parseParseObjectToHashMapRawRow_UserRecordSymptom:(PFObject*) parseObj
{
    NSLog(@"parseParseObjectToHashMapRawRow_UserRecordSymptom enter");
    if (parseObj == nil)
        return nil;
    NSMutableDictionary* dataDict = [NSMutableDictionary dictionary];
    
    NSString *key;
    id val;
    key = COLUMN_NAME_DayLocal;
    NSNumber *nmDayLocal = [parseObj objectForKey:key];
    [dataDict setObject:nmDayLocal forKey:key];
    
    key = COLUMN_NAME_UpdateTimeUTC;
    NSNumber *nmUpdateTimeUTC = [parseObj objectForKey:key];
    NSDate *UpdateTimeUTC = [LZUtility getDateFromMillisecond:[nmUpdateTimeUTC longLongValue]];
    [dataDict setObject:UpdateTimeUTC forKey:key];
    
    
    key = COLUMN_NAME_Note;
    val = [parseObj objectForKey:key];
    if (val != nil){
        [dataDict setObject:val forKey:key];
    }
    
    key = COLUMN_NAME_inputNameValuePairs;
    val = [parseObj objectForKey:key];
    if (val != nil){
        [dataDict setObject:val forKey:key];
    }
    
    key = COLUMN_NAME_calculateNameValuePairs;
    val = [parseObj objectForKey:key];
    if (val != nil){
        [dataDict setObject:val forKey:key];
    }
    
    return dataDict;
}


+(void) deleteParseObject_FoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId
{
    NSLog(@"deleteParseObject_FoodCollocationData_withCollocationId enter");
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSDictionary* foodCollocationData = [da getFoodCollocationData_withCollocationId:nmCollocationId];
    NSDictionary * nameValueDict = foodCollocationData[@"nameValueDict"];
    
    NSString *parseObjId = nil;
    if (nameValueDict!=nil)
        parseObjId = nameValueDict[KEY_NAME_ParseObjectId];
    
    if (parseObjId!=nil){
        PFObject* parseObj = [PFObject objectWithoutDataWithClassName:ParseObject_FoodCollocation objectId:parseObjId];
        [parseObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSMutableString *msg = [NSMutableString string];
            if (succeeded){
                [msg appendFormat:@"PFObject.deleteInBackgroundWithBlock FoodCollocationData OK. "];
            }else{
                [msg appendFormat:@"PFObject.deleteInBackgroundWithBlock FoodCollocationData ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
            }
            NSLog(@"when deleteParseObject_FoodCollocationData_withCollocationId, %@",msg);
        }];
    }else{
        NSLog(@"in deleteParseObject_FoodCollocationData_withCollocationId, NO parseObjId, no delete.");
    }
}

+(void) saveParseObject_FoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId
{
    NSLog(@"saveParseObject_FoodCollocationData_withCollocationId enter");
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSDictionary* foodCollocationData = [da getFoodCollocationData_withCollocationId:nmCollocationId];
    NSDictionary * rowFoodCollocation = foodCollocationData[@"rowFoodCollocation"];
    NSArray *foodAndAmount2LevelArray = foodCollocationData[@"foodAndAmount2LevelArray"];
    NSDictionary * nameValueDict = foodCollocationData[@"nameValueDict"];
    
    NSString *parseObjId = nil;
    if (nameValueDict!=nil)
        parseObjId = nameValueDict[KEY_NAME_ParseObjectId];
    
    PFObject* parseObj = nil;
    BOOL isInsert = (parseObjId==nil);
    if (isInsert)
        parseObj = [PFObject objectWithClassName:ParseObject_FoodCollocation];
    else
        parseObj = [PFObject objectWithoutDataWithClassName:ParseObject_FoodCollocation objectId:parseObjId];
    
    NSString *uniqueDeviceId = [LZUtility uniqueDeviceId];
    [parseObj setObject:uniqueDeviceId forKey:ParseObjectKey_FoodCollocation_deviceId];
    [parseObj setObject:nmCollocationId forKey:COLUMN_NAME_CollocationId];
    [parseObj setObject:rowFoodCollocation[COLUMN_NAME_CollocationName] forKey:COLUMN_NAME_CollocationName];
    [parseObj setObject:rowFoodCollocation[COLUMN_NAME_CollocationCreateTime] forKey:COLUMN_NAME_CollocationCreateTime];
    
    CJSONSerializer * CJSONSerializer1 = [CJSONSerializer serializer];
    NSError *error = NULL;
    
    if (foodAndAmount2LevelArray!=nil){
        NSData *jsonData_foodAndAmount2LevelArray = [CJSONSerializer1 serializeObject:foodAndAmount2LevelArray error:&error];
        assert(error == NULL);
        NSString *jsonString_foodAndAmount2LevelArray = [[NSString alloc] initWithData:jsonData_foodAndAmount2LevelArray encoding:NSUTF8StringEncoding];
        [parseObj setObject:jsonString_foodAndAmount2LevelArray forKey:ParseObjectKey_FoodCollocation_foodAndAmount2LevelArray];
        
//        //Error: invalid type for key foodAndAmount2LevelArray, expected string, but got object (Code: 111, Version: 1.2.18)
//        [parseObj setObject:foodAndAmount2LevelArray forKey:ParseObjectKey_FoodCollocation_foodAndAmount2LevelArray];
    }
    
    if (nameValueDict!=nil){
        NSData *jsonData_nameValueDict = [CJSONSerializer1 serializeObject:nameValueDict error:&error];
        assert(error == NULL);
        NSString *jsonString_nameValueDict = [[NSString alloc] initWithData:jsonData_nameValueDict encoding:NSUTF8StringEncoding];
        [parseObj setObject:jsonString_nameValueDict forKey:ParseObjectKey_FoodCollocation_nameValueDict];
        
    }
    
    [parseObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSMutableString *msg = [NSMutableString string];
        if (succeeded){
            [msg appendFormat:@"PFObject.saveInBackgroundWithBlock FoodCollocationData OK. "];
            
            if (isInsert){
                bool status_savePObjIdToDB = [da insertFoodCollocationParam_withId:nmCollocationId andParamName:KEY_NAME_ParseObjectId andParamValue:parseObj.objectId];
                [msg appendFormat:@"isInsert, save ParseObjectId to db=%d",status_savePObjIdToDB ];
            }
            
        }else{
            [msg appendFormat:@"PFObject.saveInBackgroundWithBlock FoodCollocationData ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
        }
        NSLog(@"when saveParseObject_FoodCollocationData_withCollocationId, %@",msg);
    }];
}

+(NSMutableDictionary*) parseParseObjectForDA_FoodCollocationData:(PFObject*) parseObj
{
    NSLog(@"parseParseObjectForDA_FoodCollocationData enter");
    if (parseObj == nil)
        return nil;
    NSMutableDictionary* dataDict = [NSMutableDictionary dictionary];
    
    NSString *key;
    key = COLUMN_NAME_CollocationId;
    [dataDict setObject:[parseObj objectForKey:key] forKey:key];
    
    key = COLUMN_NAME_CollocationName;
    [dataDict setObject:[parseObj objectForKey:key] forKey:key];
    
    key = COLUMN_NAME_CollocationCreateTime;
    [dataDict setObject:[parseObj objectForKey:key] forKey:key];
    
    key = ParseObjectKey_FoodCollocation_foodAndAmount2LevelArray;
//    NSArray *foodAndAmount2LevelArray = [parseObj objectForKey:key];
//    if (foodAndAmount2LevelArray != nil){
//        [dataDict setObject:foodAndAmount2LevelArray forKey:key];
//    }
    NSString *jsonString_foodAndAmount2LevelArray = [parseObj objectForKey:key];
    if (jsonString_foodAndAmount2LevelArray != nil){
        NSData *jsonData = [jsonString_foodAndAmount2LevelArray dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err = nil;
        NSArray *ary2D = [[CJSONDeserializer deserializer] deserialize:jsonData error:&err];
        [dataDict setObject:ary2D forKey:key];
    }

    key = ParseObjectKey_FoodCollocation_nameValueDict;
    NSDictionary * nameValueDict = nil;

    NSString *jsonString_nameValueDict = [parseObj objectForKey:key];
    if (jsonString_nameValueDict != nil){
        NSData *jsonData = [jsonString_nameValueDict dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err = nil;
        nameValueDict = [[CJSONDeserializer deserializer] deserialize:jsonData error:&err];
    }
    NSMutableDictionary * nameValueDict2 = [NSMutableDictionary dictionary];
    if (nameValueDict != nil){
        [nameValueDict2 addEntriesFromDictionary:nameValueDict];
    }
    
    nameValueDict2[KEY_NAME_ParseObjectId] = parseObj.objectId;//or assert
    [dataDict setObject:nameValueDict2 forKey:key];
    
    return dataDict;
}


+(PFQuery*) getParseQueryByCurrentDeviceForFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId
{
    NSLog(@"getParseQueryByCurrentDeviceForFoodCollocationData_withCollocationId enter");
    NSString *uniqueDeviceId = [LZUtility uniqueDeviceId];
    PFQuery *pQuery = [PFQuery queryWithClassName:ParseObject_FoodCollocation];
    [pQuery whereKey:ParseObjectKey_FoodCollocation_deviceId equalTo:uniqueDeviceId];
    [pQuery whereKey:COLUMN_NAME_CollocationId equalTo:nmCollocationId];
    return pQuery;
}

+(PFQuery*) getParseQueryByCurrentDeviceForFoodCollocationData
{
    NSLog(@"getParseQueryByCurrentDeviceForFoodCollocationData enter");
    NSString *uniqueDeviceId = [LZUtility uniqueDeviceId];
    NSLog(@"uniqueDeviceId=%@",uniqueDeviceId);
    PFQuery *pQuery = [PFQuery queryWithClassName:ParseObject_FoodCollocation];
    [pQuery whereKey:ParseObjectKey_FoodCollocation_deviceId equalTo:uniqueDeviceId];
    [pQuery addAscendingOrder:COLUMN_NAME_CollocationId];
    return pQuery;
}



+(void) syncRemoteDataToLocal_withJustCallback:(JustCallbackBlock) justCallback
{
    NSLog(@"syncRemoteDataToLocal_withJustCallback enter");
    LZDataAccess *da = [LZDataAccess singleton];//注意这条语句必须在最前。由于db那边的更新是每次升级都会删掉以前的数据库。导致这里也得每次升级时再同步一下。而且这依赖于db。
    
    NSString *flagKey = [LZUtility getPersistKey_ByEachVersion_alreadyLoadFromRemoteDataInParse];
    BOOL alreadyLoadFromRemote = [[NSUserDefaults standardUserDefaults]boolForKey:flagKey];
    if (alreadyLoadFromRemote){
        if (justCallback!=nil){
            justCallback(true);
        }
        NSLog(@"syncRemoteDataToLocal_withJustCallback exit1");
        return;
    }
    
    PFQuery *queryRemote_UserRecordSymptom = [self getParseQueryByCurrentDeviceForUserRecordSymptom];
    NSLog(@"syncRemoteDataToLocal_withJustCallback findObjectsInBackgroundWithBlock begin");
    [queryRemote_UserRecordSymptom findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"syncRemoteDataToLocal_withJustCallback findObjectsInBackgroundWithBlock return");
        NSMutableString *msg = [NSMutableString string];
        bool succeeded = (error==nil);
        if (!succeeded){
            [msg appendFormat:@" query.findObjectsInBackgroundWithBlock UserRecordSymptom ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
        }else{
            if (objects.count==0){
                [msg appendFormat:@" No data in remote."];
            }else{
                [msg appendFormat:@" Have %d rows in remote.",objects.count];
                
                
                for(int i=0; i<objects.count; i++){
                    PFObject* parseObj = objects[i];
                    
                    NSMutableDictionary *hmRawRow = [self parseParseObjectToHashMapRawRow_UserRecordSymptom:parseObj];
                    NSNumber *nmDayLocal = hmRawRow[COLUMN_NAME_DayLocal];
                    NSDictionary *row = [da getUserRecordSymptomDataByDayLocal:[nmDayLocal intValue]];
                    if (row == nil){
                        [da insertUserRecordSymptom_withRawData:hmRawRow];
                        if (i==objects.count-1){
                            NSNumber *nmDayLocal = [hmRawRow objectForKey:COLUMN_NAME_DayLocal];
                            [self saveParseObjectInfo_CurrentUserRecordSymptom_withParseObjectId:parseObj.objectId andDayLocal:[nmDayLocal intValue]];
                        }
                    }
                }//for
            }
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:flagKey];
//            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        NSLog(@"in syncRemoteDataToLocal_withJustCallback msg1=%@",msg);
        
        if (!succeeded){//前面的都失败了，后面的就不继续了
            if (justCallback!=nil){
                justCallback(succeeded);
            }
            return ;
        }
        
        PFQuery *queryRemote_FoodCollocation = [self getParseQueryByCurrentDeviceForFoodCollocationData];
        [queryRemote_FoodCollocation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSMutableString *msg = [NSMutableString string];
            bool succeeded = (error==nil);
            if (!succeeded){
                [msg appendFormat:@" query.findObjectsInBackgroundWithBlock FoodCollocation ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
            }else{
                if (objects.count==0){
                    [msg appendFormat:@" No data in remote."];
                }else{
                    [msg appendFormat:@" Have %d rows in remote.",objects.count];
                    
                    LZDataAccess *da = [LZDataAccess singleton];
                    for(int i=0; i<objects.count; i++){
                        PFObject* parseObj = objects[i];
                        NSMutableDictionary *hmData = [self parseParseObjectForDA_FoodCollocationData:parseObj];
                        NSNumber *nmCollocationId = hmData[COLUMN_NAME_CollocationId];
                        NSDictionary *row = [da getFoodCollocationById:nmCollocationId];
                        if (row == nil){
                            NSNumber *nmCreateTime = hmData[COLUMN_NAME_CollocationCreateTime];
                            [da insertFoodCollocationData_withCollocationName:hmData[COLUMN_NAME_CollocationName] andCreateTime:[nmCreateTime longLongValue] andCollocationId:nmCollocationId andFoodAmount2LevelArray:hmData[ParseObjectKey_FoodCollocation_foodAndAmount2LevelArray] andFoodCollocationParamNameValueDict:hmData[ParseObjectKey_FoodCollocation_nameValueDict]];
                        }
                    }//for
                }
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:flagKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            NSLog(@"in syncRemoteDataToLocal_withJustCallback msg2=%@",msg);
            
            if (justCallback!=nil){
                justCallback(succeeded);
            }
        }];
    }];
}




@end
