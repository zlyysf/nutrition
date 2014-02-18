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
#import "LZUtility.h"
#import "LZUtilityParse.h"
#import "LZDataAccess.h"
#import "LZReviewAppManager.h"
#import "LZNutrientionManager.h"
#import <Parse/Parse.h>
#import "LZTest1.h"

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
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"nav_bar@2x" ofType:@"png"];
//    UIImage * navImage = [UIImage imageWithContentsOfFile:path];
//    UIImage *gradientImage44 = [navImage
//                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [[UINavigationBar appearance]setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
//    [[UISearchBar appearance]setImage:[UIImage imageNamed:@"search_glass.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    [[UISearchBar appearance]setPositionAdjustment:UIOffsetMake(0, 1) forSearchBarIcon:UISearchBarIconSearch];
//    UIImage *button30 = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
//    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    UIImage *buttonBack30 = [[UIImage imageNamed:@"nav_back_button"]
//                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
//    
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack30
//                                                      forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
//    [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"tabbar_back.png"]];
//    [[UITabBar appearance] setSelectedImageTintColor:[UIColor greenColor]];
    if (IOS7_OR_LATER)
    {
        [[UINavigationBar appearance]setTintColor:[UIColor colorWithRed:67/255.f green:113/255.f blue:71/255.f alpha:1.0f]];
        [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:204/255.f green:255/255.f blue:204/255.f alpha:1.0f]];
//        [[UITabBar appearance]setTintColor:[UIColor colorWithRed:0.f green:204/255.f blue:51/255.f alpha:1.0f]];
        [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:25],UITextAttributeFont,[UIColor colorWithRed:6/255.f green:62/255.f blue:4/255.f alpha:1.0f],UITextAttributeTextColor, nil]];
    }
    else
    {
        [[UINavigationBar appearance]setTintColor:[UIColor colorWithRed:29/255.f green:120/255.f blue:41/255.f alpha:1.0f]];
        //[UIColor colorWithRed:0.f green:204/255.f blue:51/255.f alpha:1.0f]
        
        [[UITabBar appearance]setSelectedImageTintColor:[UIColor colorWithRed:29/255.f green:120/255.f blue:41/255.f alpha:1.0f]];
        [[UITabBar appearance]setTintColor:[UIColor blackColor]];
    }
//    ;
//    [LZUtility initializePreferNutrient];
    //友盟统计SDK启
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [LZDataAccess singleton];
//    LZDataAccess *da = [LZDataAccess singleton];
//    NSArray *suggestionArray = [da getIllnessSuggestionsDistinct_ByIllnessIds:nil];
//    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
//    for (NSDictionary *aSuggestion in suggestionArray)
//    {
//        NSString *suggestionId = [aSuggestion objectForKey:@"SuggestionId"];
//        [tempDict setObject:aSuggestion forKey:suggestionId];
//    }
//    self.suggestionDict = [NSDictionary dictionaryWithDictionary:tempDict];
    [LZUtility setReviewFlagForNewVersion];
    [MobClick startWithAppkey:UMSDKAPPKey];
    //[MobClick startWithAppkey:UMSDKAPPKey reportPolicy:REALTIME channelId:MobChannelIdAppStore];
    //检查更新
    [MobClick checkUpdate:NSLocalizedString(@"umeng_checkupdate_title",@"检测到新版本") cancelButtonTitle:NSLocalizedString(@"umeng_checkupdate_cancel",@"下次再说" )otherButtonTitles:NSLocalizedString(@"umeng_checkupdate_other",@"去下载")];
    //initialize persons and days setting
//    [ShareSDK registerApp:ShareSDKAPPKey];
//    [ShareSDK connectSinaWeiboWithAppKey:SinaWeiboAppKey
//                               appSecret:SinaWeiboAppSecret
//                             redirectUri:@"http://www.lingzhimobile.com/"];
//    [ShareSDK connectWeChatWithAppId:WeChatAppId wechatCls:[WXApi class]];
    [LZNutrientionManager SharedInstance];

//    NSNumber *checkReminderState = [[NSUserDefaults standardUserDefaults]objectForKey:KeyHealthCheckReminderState];
//    if (checkReminderState == nil)
//    {
//        NSNumber *stateOn = [NSNumber numberWithBool:YES];
//        [[NSUserDefaults standardUserDefaults]setObject:stateOn forKey:KeyHealthCheckReminderState];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//    [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:58/255.f green:170/255.f blue:44/255.f alpha:1.f]];
//    UILocalNotification *localNotify = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
//    if (localNotify != nil)
//    {
//        if ([LZUtility isUserProfileComplete])
//        {
//            NSSet *keySet = [NSSet setWithObjects:KeyCheckReminderXiaWu,KeyCheckReminderShangWu,KeyCheckReminderShuiQian, nil];
//            NSDictionary *info = [localNotify userInfo];
//            if(info != nil && [keySet containsObject:[info objectForKey:@"notifyType"]])
//            {
//                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:KeyAppLauchedForHealthCheck];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//            }
//        }
//    }
    
    [Parse setApplicationId:ParseApp_ApplicationID clientKey:ParseApp_ClientKey];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound];
    
    //To ensure accurate "Push Opens" statistics
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double counting
        // the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:true];
    [defaultACL setPublicWriteAccess:true];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:true];
    
    [LZUtilityParse syncRemoteDataToLocal_withJustCallback:nil];
    
//    [LZTest1 test_genData_UserRecordSymptom1];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}


//-(void)handleLocalNotify:(UILocalNotification*)localNotify
//{
//    if(localNotify == nil)
//    {
//        return;
//    }
//    else if ([LZUtility isUserProfileComplete])
//    {
//        NSSet *keySet = [NSSet setWithObjects:KeyCheckReminderXiaWu,KeyCheckReminderShangWu,KeyCheckReminderShuiQian, nil];
//        NSDictionary *info = [localNotify userInfo];
//        if(info != nil && [keySet containsObject:[info objectForKey:@"notifyType"]])
//        {
//            UIViewController *rootvc =[UIApplication sharedApplication].keyWindow.rootViewController;
//            if ([rootvc isKindOfClass:[JWNavigationViewController class]] || rootvc == nil)
//            {
//                
//                for (UIWindow* w in [UIApplication sharedApplication].windows)
//                {
//                    [self closeActionSheet:w];
////                    for (NSObject* o in w.subviews)
////                    {
////                        if ([o isKindOfClass:[UIAlertView class]])
////                        {
////                            [(UIAlertView*)o dismissWithClickedButtonIndex:[(UIAlertView*)o cancelButtonIndex] animated:NO];
////                        }
////                        else if ([o isKindOfClass:[LZNutritionInfoView class]])
////                        {
////                            [(LZNutritionInfoView*)o removeFromSuperview];
////                        }
////                    }
//                }
//                UINavigationController *mainNav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                [mainNav.visibleViewController dismissModalViewControllerAnimated:NO];
//                
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//                LZHealthCheckViewController *healthCheckViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZHealthCheckViewController"];
//                healthCheckViewController.backWithNoAnimation = YES;
//                LZMainPageViewController *mainPageViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZMainPageViewController"];
//                NSDictionary *emptyIntake = [[NSDictionary alloc]init];
//                [[NSUserDefaults standardUserDefaults] setObject:emptyIntake forKey:LZUserDailyIntakeKey];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                
//                NSArray *vcs = [NSArray arrayWithObjects:mainPageViewController,healthCheckViewController, nil];
//                
//                [mainNav setViewControllers:vcs animated:YES];
//            }
//        }
//    }
//}
//-(void)closeActionSheet:(UIView *)aView
//{
//    if (aView) {
//        if ([aView isKindOfClass:[UIActionSheet class]]) {
//            [(UIActionSheet *)aView dismissWithClickedButtonIndex:[(UIActionSheet*)aView cancelButtonIndex] animated:NO];
//        }
//        else if ([aView isKindOfClass:[UIAlertView class]])
//        {
//            [(UIAlertView*)aView dismissWithClickedButtonIndex:[(UIAlertView*)aView cancelButtonIndex] animated:NO];
//        }
//        else if ([aView isKindOfClass:[LZNutritionInfoView class]])
//        {
//            [(LZNutritionInfoView*)aView removeFromSuperview];
//        }
//        else if ([aView isKindOfClass:[LZRecommendFilterView class]])
//        {
//            [(LZRecommendFilterView*)aView removeFromSuperview];
//        }
//        else if ([aView isKindOfClass:[LZCheckTypeSwitchView class]])
//        {
//            [(LZCheckTypeSwitchView*)aView removeFromSuperview];
//        }
//        else if (aView.subviews.count > 0) {
//            for (UIView* aSubview in aView.subviews) {
//                [self closeActionSheet:aSubview];
//            }
//        }
//    }
//}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    NSSet *keySet = [NSSet setWithObjects:KeyCheckReminderXiaWu,KeyCheckReminderShangWu,KeyCheckReminderShuiQian, nil];
//    NSArray *oldScheduledNotify = [[UIApplication sharedApplication]scheduledLocalNotifications];
//    NSMutableArray *newScheduled = [[NSMutableArray alloc]init];
//
//    for (UILocalNotification * localNotify in oldScheduledNotify)
//    {
//        NSDictionary *info = [localNotify userInfo];
//        if(info != nil && [keySet containsObject:[info objectForKey:@"notifyType"]])
//        {
//            [newScheduled addObject:localNotify];
//        }
//    }
    
    UILocalNotification *local = [[UILocalNotification alloc]init];
    [local setAlertAction:NSLocalizedString(@"localnotify_3dayreminder_action",@"打开")];
    [local setAlertBody:NSLocalizedString(@"localnotify_3dayreminder_content",@"营养膳食指南竭诚帮您选出含有全面丰富营养的食物搭配，敬请使用!")];
    [local setApplicationIconBadgeNumber:1];
    NSDate *currentDate = [NSDate date];
    [local setFireDate:[currentDate dateByAddingTimeInterval:LocalNotifyTimeInterval]];
    [local setTimeZone:[NSTimeZone defaultTimeZone]];
    [local setSoundName:UILocalNotificationDefaultSoundName];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:KeyNotifyTimeTypeReminder forKey:@"notifyType"];
    [local setUserInfo:infoDict];
//    [newScheduled addObject:local];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
//    NSSet *keySet = [NSSet setWithObjects:KeyCheckReminderXiaWu,KeyCheckReminderShangWu,KeyCheckReminderShuiQian, nil];
//    NSArray *oldScheduledNotify = [[UIApplication sharedApplication]scheduledLocalNotifications];
//    NSMutableArray *newScheduled = [[NSMutableArray alloc]init];
//    
//    for (UILocalNotification * localNotify in oldScheduledNotify)
//    {
//        NSDictionary *info = [localNotify userInfo];
//        if(info != nil && [keySet containsObject:[info objectForKey:@"notifyType"]])
//        {
//            [newScheduled addObject:localNotify];
//        }
//    }
//    [[UIApplication sharedApplication] setScheduledLocalNotifications:newScheduled];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    if ([application respondsToSelector:@selector(applicationState)] && application.applicationState != UIApplicationStateActive)
//    {
//        [self handleLocalNotify:notification];
//    }
//    else
//    {
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
//    }
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
//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
//}
//
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString  *)sourceApplication
//         annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}
@end
