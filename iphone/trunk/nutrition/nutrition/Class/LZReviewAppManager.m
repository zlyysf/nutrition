//
//  LZReviewAppManager.m
//  nutrition
//
//  Created by liu miao on 6/13/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZReviewAppManager.h"

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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"评分" message:@"如果你喜欢买菜助手, 你是否愿意花一点时间为我们的产品评分? 谢谢您的支持!" delegate:self cancelButtonTitle:@"不, 谢谢" otherButtonTitles:@"现在就评分",@"稍后评分", nil];
    [alert show];
}
-(void)reviewOurAppDirectly
{
    NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: @"https://itunes.apple.com/app/id658111966" ];
    [[UIApplication sharedApplication] openURL:ourAppUrl];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index : %d",buttonIndex);
    if (buttonIndex == alertView.cancelButtonIndex)//0
    {//不，谢谢
        
    }
    else if (buttonIndex == 1)//1
    {//现在就评分
        [self reviewOurAppDirectly];
    }
    else//2
    {//稍后评分
        
    }
}

@end
