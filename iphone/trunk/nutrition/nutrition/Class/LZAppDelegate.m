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
@implementation LZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    //custom navigationbar and barbuttonitem
    NSString *path = [[NSBundle mainBundle] pathForResource:@"nav_bar@2x" ofType:@"png"];
    UIImage * navImage = [UIImage imageWithContentsOfFile:path];
    UIImage *gradientImage44 = [navImage
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance]setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    
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
    [MobClick startWithAppkey:UMSDKAPPKey];
    //检查更新
    [MobClick checkUpdate:@"检测到新版本" cancelButtonTitle:@"下次再说" otherButtonTitles:@"去AppStore"];
    //initialize persons and days setting
    [ShareSDK registerApp:ShareSDKAPPKey];
    [ShareSDK connectSinaWeiboWithAppKey:SinaWeiboAppKey
                               appSecret:SinaWeiboAppSecret
                             redirectUri:@"http://www.lingzhimobile.com/"];
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"];
    [ShareSDK connectWeChatWithAppId:WeChatAppId wechatCls:[WXApi class]];
    NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
    NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
    if (planPerson == nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanPersonsKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if (planDays == nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanDaysKey];
        [[NSUserDefaults standardUserDefaults]synchronize];

    }
    //[7/2/13 2:31:44 PM] 芯如: 66c13e 102 193 62
    //[7/2/13 2:31:53 PM] 芯如: 0f941a 15 148 26
    //[7/2/13 2:32:08 PM] 芯如: 3aaa2c 58 170 44
    //[[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:102/255.f green:193/255.f blue:62/255.f alpha:1.f]];
    //[[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:15/255.f green:148/255.f blue:26/255.f alpha:1.f]];
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:58/255.f green:170/255.f blue:44/255.f alpha:1.f]];
    //[[UISwitch appearance] setTintColor:[UIColor colorWithRed:1.000 green:0.989 blue:0.753 alpha:1.000]];
    //[[UISwitch appearance] setThumbTintColor:[UIColor colorWithRed:0.211 green:0.550 blue:1.000 alpha:1.000]];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    UILocalNotification *local = [[UILocalNotification alloc]init];
    [local setAlertAction:@"打开"];
    [local setAlertBody:@"营养宝典竭诚为您推荐含有全面丰富营养的食物搭配，敬请使用"];
    [local setApplicationIconBadgeNumber:1];
    NSDate *currentDate = [NSDate date];
    [local setFireDate:[currentDate dateByAddingTimeInterval:LocalNotifyTimeInterval]];
    [local setTimeZone:[NSTimeZone defaultTimeZone]];
    [local setSoundName:UILocalNotificationDefaultSoundName];
    //NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"一分钟后触发" forKey:@"notifyType"];
    //[local setUserInfo:infoDict];
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
