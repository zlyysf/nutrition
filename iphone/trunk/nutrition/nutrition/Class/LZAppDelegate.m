//
//  LZAppDelegate.m
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZAppDelegate.h"
#import "LZConstants.h"
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "LZUtility.h"
#import "LZDataAccess.h"
#import "LZReviewAppManager.h"
@implementation LZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [LZUtility initializeCheckReminder];
    //custom navigationbar and barbuttonitem
    if(KeyIsEnvironmentDebug)
    {
        [self initialDebugSettings];//add some debug settings key in user default
    }
    else
    {
        [self cleanDebugSettings];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"nav_bar@2x" ofType:@"png"];
    UIImage * navImage = [UIImage imageWithContentsOfFile:path];
    UIImage *gradientImage44 = [navImage
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance]setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    [[UISearchBar appearance]setImage:[UIImage imageNamed:@"search_glass.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UISearchBar appearance]setPositionAdjustment:UIOffsetMake(0, 1) forSearchBarIcon:UISearchBarIconSearch];
    UIImage *button30 = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *buttonBack30 = [[UIImage imageNamed:@"nav_back_button"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack30
                                                      forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"tabbar_back.png"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor greenColor]];
    [[UITabBar appearance]setTintColor:[UIColor lightGrayColor]];
    [LZUtility initializePreferNutrient];
    //友盟统计SDK启
    [LZDataAccess singleton];
    [LZUtility setReviewFlagForNewVersion];
    [MobClick startWithAppkey:UMSDKAPPKey];
    //[MobClick startWithAppkey:UMSDKAPPKey reportPolicy:REALTIME channelId:MobChannelIdAppStore];
    //检查更新
    [MobClick checkUpdate:@"检测到新版本" cancelButtonTitle:@"下次再说" otherButtonTitles:@"去下载"];
    //initialize persons and days setting
    [ShareSDK registerApp:ShareSDKAPPKey];
    [ShareSDK connectSinaWeiboWithAppKey:SinaWeiboAppKey
                               appSecret:SinaWeiboAppSecret
                             redirectUri:@"http://www.lingzhimobile.com/"];
    [ShareSDK connectWeChatWithAppId:WeChatAppId wechatCls:[WXApi class]];
    NSNumber *checkReminderState = [[NSUserDefaults standardUserDefaults]objectForKey:KeyHealthCheckReminderState];
    if (checkReminderState == nil)
    {
        NSNumber *stateOn = [NSNumber numberWithBool:YES];
        [[NSUserDefaults standardUserDefaults]setObject:stateOn forKey:KeyHealthCheckReminderState];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
//    NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
//    NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
//    if (planPerson == nil)
//    {
//        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanPersonsKey];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//    if (planDays == nil)
//    {
//        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanDaysKey];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//
//    }
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:58/255.f green:170/255.f blue:44/255.f alpha:1.f]];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //[[UIApplication sharedApplication]cancelAllLocalNotifications];
    NSSet *keySet = [NSSet setWithObjects:KeyCheckReminderXiaWu,KeyCheckReminderShangWu,KeyCheckReminderShuiQian, nil];
    NSArray *oldScheduledNotify = [[UIApplication sharedApplication]scheduledLocalNotifications];
    NSMutableArray *newScheduled = [[NSMutableArray alloc]init];

    for (UILocalNotification * localNotify in oldScheduledNotify)
    {
        NSDictionary *info = [localNotify userInfo];
        if(info != nil && [keySet containsObject:[info objectForKey:@"notifyType"]])
        {
            [newScheduled addObject:localNotify];
        }
    }
    
    UILocalNotification *local = [[UILocalNotification alloc]init];
    [local setAlertAction:@"打开"];
    [local setAlertBody:@"营养膳食指南竭诚帮您选出含有全面丰富营养的食物搭配，敬请使用!"];
    [local setApplicationIconBadgeNumber:1];
    NSDate *currentDate = [NSDate date];
    [local setFireDate:[currentDate dateByAddingTimeInterval:LocalNotifyTimeInterval]];
    [local setTimeZone:[NSTimeZone defaultTimeZone]];
    [local setSoundName:UILocalNotificationDefaultSoundName];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:KeyNotifyTimeTypeReminder forKey:@"notifyType"];
    [local setUserInfo:infoDict];
    [newScheduled addObject:local];
    
    [[UIApplication sharedApplication] setScheduledLocalNotifications:newScheduled];
//  NSArray *scheduledArray = [[UIApplication sharedApplication] scheduledLocalNotifications];

//  Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//  If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    NSSet *keySet = [NSSet setWithObjects:KeyCheckReminderXiaWu,KeyCheckReminderShangWu,KeyCheckReminderShuiQian, nil];
    NSArray *oldScheduledNotify = [[UIApplication sharedApplication]scheduledLocalNotifications];
    NSMutableArray *newScheduled = [[NSMutableArray alloc]init];
    
    for (UILocalNotification * localNotify in oldScheduledNotify)
    {
        NSDictionary *info = [localNotify userInfo];
        if(info != nil && [keySet containsObject:[info objectForKey:@"notifyType"]])
        {
            [newScheduled addObject:localNotify];
        }
    }
    [[UIApplication sharedApplication] setScheduledLocalNotifications:newScheduled];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)initialDebugSettings
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:KeyDebugSettingsDict];
    if (dict == nil || [[dict allKeys]count]==0)
    {
        //add settings
        NSDictionary *newDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [NSNumber numberWithBool:Config_needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                                 
                            [NSNumber numberWithBool:Config_needLimitNutrients],LZSettingKey_needLimitNutrients,
                                 [NSNumber numberWithBool:Config_needUseDefinedIncrementUnit],LZSettingKey_needUseDefinedIncrementUnit,
                            [NSNumber numberWithBool:Config_needUseNormalLimitWhenSmallIncrementLogic],LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic,
                            [NSNumber numberWithBool:Config_needUseFirstRecommendWhenSmallIncrementLogic],LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic,
                             [NSNumber numberWithBool:Config_needFirstSpecialForShucaiShuiguo],LZSettingKey_needFirstSpecialForShucaiShuiguo,
                             [NSNumber numberWithBool:Config_needSpecialForFirstBatchFoods],LZSettingKey_needSpecialForFirstBatchFoods,
                             [NSNumber numberWithBool:Config_alreadyChoosedFoodHavePriority],LZSettingKey_alreadyChoosedFoodHavePriority,
                             [NSNumber numberWithBool:Config_needPriorityFoodToSpecialNutrient],LZSettingKey_needPriorityFoodToSpecialNutrient,
                             nil];
        [[NSUserDefaults standardUserDefaults]setObject:newDict forKey:KeyDebugSettingsDict];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
-(void)cleanDebugSettings
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KeyDebugSettingsDict];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString  *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
@end
