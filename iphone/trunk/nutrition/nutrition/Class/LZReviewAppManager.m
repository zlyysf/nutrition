//
//  LZReviewAppManager.m
//  nutrition
//
//  Created by liu miao on 6/13/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZReviewAppManager.h"
#import "LZConstants.h"
@implementation LZReviewAppManager
+(LZReviewAppManager*)SharedInstance
{
    static dispatch_once_t LZRAMOnce;
    static LZReviewAppManager * sharedInstance;
    dispatch_once(&LZRAMOnce, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}
-(void)popReviewOurAppAlertAccordingRules
{
    //制定一些规则，根据某些标志位来判断是否弹出评分提示
    BOOL alreadyReviewed = [[NSUserDefaults standardUserDefaults]boolForKey:KeyIsAlreadyReviewdeOurApp];
    if (alreadyReviewed)
    {
        return;
    }
    else
    {
        int times = [[NSUserDefaults standardUserDefaults]integerForKey:KeyReviewAlertControllCount];
        times +=1;
        if (times >= 10)
        {
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:KeyReviewAlertControllCount];
            [[NSUserDefaults standardUserDefaults]synchronize];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"评分" message:@"如果你喜欢营养膳食指南, 你是否愿意花一点时间为我们的产品评分? 谢谢您的支持!" delegate:self cancelButtonTitle:@"稍后评分" otherButtonTitles:@"现在就评分", nil];
            [alert show];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setInteger:times forKey:KeyReviewAlertControllCount];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        
    }
}
-(void)reviewOurAppDirectly
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:KeyIsAlreadyReviewdeOurApp];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: @"https://itunes.apple.com/app/id658111966" ];
    [[UIApplication sharedApplication] openURL:ourAppUrl];
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//0
    {
        //现在就评分
        [self reviewOurAppDirectly];
    }

}

@end
