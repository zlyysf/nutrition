//
//  LZViewController.m
//  ImpExpTool
//
//  Created by Yasofon on 13-5-13.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZViewController.h"
#import "LZReadExcel.h"
#import "LZDBAccess.h"


@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
    
    NSString *destDbFileName = @"data1.dat";
    [workRe myInitDBConnectionWithFilePath:destDbFileName andIfNeedClear:true];

//    [workRe convertExcelToSqlite_USDA_ABBREV_withDebugFlag:true];
//    //[workRe convertExcelToSqlite_USDA_ABBREV_withDebugFlag:false];//生成正式的数据应该用这个
    
    [workRe convertDRIFemaleDataFromExcelToSqlite];
    [workRe convertDRIMaleDataFromExcelToSqlite];
    [workRe generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2];


//    LZDBAccess *db = [LZDBAccess singletonCustomDB];
    LZDBAccess *db = [workRe getDBconnection];
    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
