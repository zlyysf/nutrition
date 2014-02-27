//
//  LZReviewAppManager.m
//  nutrition
//
//  Created by liu miao on 6/13/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZReviewAppManager.h"
#import "LZConstants.h"
#import "LZUtility.h"



@interface MFMailComposeViewControllerDelegator()<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@end

@implementation MFMailComposeViewControllerDelegator


-(void)popEmailFeedbackDialog_withViewController:(UIViewController*)viewController
{
    m_viewControllerForMail = viewController;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"settings_email_title",@"用户意见反馈") message:NSLocalizedString(@"reviewapp_alert1_message",@"如果你喜欢养生胶囊, 你是否愿意花一点时间提供用户意见反馈? 谢谢您的支持!") delegate:self cancelButtonTitle:NSLocalizedString(@"quxiaobutton",@"取消") otherButtonTitles:NSLocalizedString(@"quedingbutton",@"确定"), nil];
    [alert show];
}



-(void)showEmailFeedbackDirectly
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass == nil){
        return;
    }
    if (![mailClass canSendMail]){
        return;
    }
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    [mailPicker setSubject: NSLocalizedString(@"settings_email_title",@"用户意见反馈")];
    NSArray *toRecipients = [NSArray arrayWithObjects: @"support@lingzhimobile.com",nil];
    [mailPicker setToRecipients: toRecipients];
    [mailPicker setMessageBody:@"" isHTML:NO];
    [m_viewControllerForMail presentViewController:mailPicker animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString * Key_IsAlreadyEmailFeedbackOurApp = [LZUtility getPersistKey_ByEachVersion_IsAlreadyEmailFeedbackOurApp];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:Key_IsAlreadyEmailFeedbackOurApp];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *msg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            msg = NSLocalizedString(@"settings_sendemail_result0",@"邮件保存成功");
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = NSLocalizedString(@"settings_sendemail_result1",@"邮件发送成功");
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = NSLocalizedString(@"settings_sendemail_result2",@"邮件发送失败");
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
    m_viewControllerForMail = nil;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//0
    {
        [self showEmailFeedbackDirectly];
    }else{
        m_viewControllerForMail = nil;
    }
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"xinxi_c_queding",@"alert确定按钮：确定")
                                          otherButtonTitles:nil];
    [alert show];
}

@end



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
-(void)popReviewOurAppAlertAccordingRules_withViewController:(UIViewController*)viewController
{
    //制定一些规则，根据某些标志位来判断是否弹出评分提示
    NSString * Key_IsAlreadyReviewdeOurApp = [LZUtility getPersistKey_ByEachVersion_IsAlreadyReviewdeOurApp];
    int times = [[NSUserDefaults standardUserDefaults]integerForKey:KeyReviewAlertControllCount];
    times +=1;
    [[NSUserDefaults standardUserDefaults]setInteger:times forKey:KeyReviewAlertControllCount];
    [[NSUserDefaults standardUserDefaults]synchronize];
    BOOL alreadyReviewed = [[NSUserDefaults standardUserDefaults]boolForKey:Key_IsAlreadyReviewdeOurApp];
    if (alreadyReviewed)
    {
        NSString * Key_IsAlreadyEmailFeedbackOurApp = [LZUtility getPersistKey_ByEachVersion_IsAlreadyEmailFeedbackOurApp];
        BOOL alreadyFeedback = [[NSUserDefaults standardUserDefaults]boolForKey:Key_IsAlreadyEmailFeedbackOurApp];
        if (!alreadyFeedback){
            //if (times > 0 && times % 3 == 0){
            if (times > 0 && times % 50 == 0){
                if (m_MFMailComposeViewControllerDelegator == nil)
                    m_MFMailComposeViewControllerDelegator = [[MFMailComposeViewControllerDelegator alloc]init];
                [m_MFMailComposeViewControllerDelegator popEmailFeedbackDialog_withViewController:viewController];
            }
        }
    }
    else
    {
        if (times >= 20)
        {
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:KeyReviewAlertControllCount];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self popReviewDialog];
        }
    }
}

-(void)popReviewDialog
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"reviewapp_alert0_title",@"评分") message:NSLocalizedString(@"reviewapp_alert0_message",@"如果你喜欢养生胶囊, 你是否愿意花一点时间为我们的产品评分? 谢谢您的支持!") delegate:self cancelButtonTitle:NSLocalizedString(@"shaohoupingfenbutton",@"稍后评分") otherButtonTitles:NSLocalizedString(@"xianzaijiupingfenbutton",@"现在就评分"), nil];
    [alert show];
}

-(void)reviewOurAppDirectly
{
    NSString * Key_IsAlreadyReviewdeOurApp = [LZUtility getPersistKey_ByEachVersion_IsAlreadyReviewdeOurApp];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:Key_IsAlreadyReviewdeOurApp];
    [[NSUserDefaults standardUserDefaults]synchronize];
//    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
//    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
//    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
//    // Here is the app id from itunesconnect
//    str = [NSString stringWithFormat:@"%@658111966", str];
    
    NSString *idApp = @"658111966";
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?at=10l6dK", idApp];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    //NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: @"https://itunes.apple.com/app/id658111966" ];
    //[[UIApplication sharedApplication] openURL:ourAppUrl];
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
