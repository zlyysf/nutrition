//
//  LZSettingsViewController.m
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZSettingsViewController.h"
#import "LZConstants.h"
#import "LZKeyboardToolBar.h"
#import "LZReviewAppManager.h"
#import <MessageUI/MessageUI.h>
#import <ShareSDK/ShareSDK.h>
@interface LZSettingsViewController ()<LZKeyboardToolBarDelegate,MFMailComposeViewControllerDelegate>

@end

@implementation LZSettingsViewController
@synthesize currentTextField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    UIImage *textImage = [UIImage imageNamed:@"setting_text_back.png"];
    UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    [self.personsBackImageView setImage:textBackImage];
    [self.daysBackImageView setImage:textBackImage];
    [self.tipsLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f]];
    self.tipsLabel.text = @"我们默认向您推荐一个成年人一天的食物量，您在给家庭大采购时可以适当调整人数和天数，但只能输入一位数字。";
	// Do any additional setup after loading the view.
    //显示目前设定的人数 天数
 }
- (void)viewWillAppear:(BOOL)animated
{
    NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
    NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
    if (planPerson != nil)
    {
        self.personsTextField.text = [NSString stringWithFormat:@"%d",[planPerson intValue]];
    }
    else
    {
        self.personsTextField.text = [NSString stringWithFormat:@"%d",1];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanPersonsKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if (planDays != nil)
    {
        self.daysTextField.text = [NSString stringWithFormat:@"%d",[planDays intValue]];
    }
    else
    {
        self.daysTextField.text = [NSString stringWithFormat:@"%d",1];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanDaysKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

}
- (IBAction)shareButtonTapped:(id)sender {
    //弹出平台菜单
//    NSString *imagePath =  [[NSBundle mainBundle] pathForResource:@"ShareSDK"
//                                                           ofType:@"jpg"];
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
//                                       defaultContent:@"默认分享内容，没内容时显示"
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:@"ShareSDK"
//                                                  url:@"http://www.sharesdk.cn"
//                                          description:@"这是一条测试信息"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    [ShareSDK showShareActionSheet:nil
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions: nil
//                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                if (state == SSPublishContentStateSuccess)
//                                {
//                                    NSLog(@"分享成功");
//                                }
//                                else if (state == SSPublishContentStateFail)
//                                {
//                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
//                                }
//                            }];
    
    
    
    //直接出分享页面
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"];
//    
//    id<ISSContent> publishContent = [ShareSDK content:@"content"
//                                       defaultContent:@""
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:nil
//                                                  url:nil
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeText];
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender
//                            arrowDirect:UIPopoverArrowDirectionUp];
//    
//    //显示分享菜单
//    [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
//                          container:container
//                            content:publishContent
//                      statusBarTips:YES
//                        authOptions:nil
//                       shareOptions:nil
//                             result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                 if (state == SSPublishContentStateSuccess)
//                                 {
//                                     NSLog(@"发表成功");
//                                 }
//                                 else if (state == SSPublishContentStateFail)
//                                 {
//                                     NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
//                                 }
//                             }];
    
    //直接分享
    //创建分享内容
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"];
    
    id<ISSContent> publishContent = [ShareSDK content:@"content"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"分享成功");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
                        }
                    }];

}
- (IBAction)reviewOurApp:(id)sender {
    [[LZReviewAppManager SharedInstance]popReviewOurAppAlertAccordingRules];
}
- (IBAction)userFeedBack:(id)sender {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
    }

}
-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"用户意见反馈"];
    
    //添加发送者
    NSArray *toRecipients = [NSArray arrayWithObjects: @"lingzhi@support.com",nil];
    
    [mailPicker setToRecipients: toRecipients];
    
    
    
    //设置正文
    //    //NSString *emailBody = self.recommendTextView.text;
    //    NSString *emailBody = txtCalculateInfo;
    //    [mailPicker setMessageBody:emailBody isHTML:NO];
    //NSString *emailBody = htmlCalculateInfo;
    //[mailPicker setMessageBody:emailBody isHTML:YES];
    
    
    
    [self presentViewController:mailPicker animated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)saveChanges:(id)sender
{
    [currentTextField resignFirstResponder];
    int persons = [self.personsTextField.text intValue];
    int days = [self.daysTextField.text intValue];
    if (persons <=0 || days <=0 || persons >= 10 || days>= 10)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入合适的数字" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
        NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
        if (planPerson != nil)
        {
            self.personsTextField.text = [NSString stringWithFormat:@"%d",[planPerson intValue]];
        }
        else
        {
            self.personsTextField.text = [NSString stringWithFormat:@"%d",1];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanPersonsKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        if (planDays != nil)
        {
            self.daysTextField.text = [NSString stringWithFormat:@"%d",[planDays intValue]];
        }
        else
        {
            self.daysTextField.text = [NSString stringWithFormat:@"%d",1];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanDaysKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:days] forKey:LZPlanDaysKey];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:persons] forKey:LZPlanPersonsKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_SettingsChangedKey object:nil userInfo:nil];
}
- (IBAction)cancelChanges:(id)sender
{
    [currentTextField resignFirstResponder];
    NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
    NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
    if (planPerson != nil)
    {
        self.personsTextField.text = [NSString stringWithFormat:@"%d",[planPerson intValue]];
    }
    else
    {
        self.personsTextField.text = [NSString stringWithFormat:@"%d",1];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanPersonsKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if (planDays != nil)
    {
        self.daysTextField.text = [NSString stringWithFormat:@"%d",[planDays intValue]];
    }
    else
    {
        self.daysTextField.text = [NSString stringWithFormat:@"%d",1];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanDaysKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UItextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    LZKeyboardToolBar *keyboardToolbar = [[LZKeyboardToolBar alloc]initWithFrame:kKeyBoardToolBarRect doneButtonTitle:@"完成" delegate:self];
    textField.inputAccessoryView = keyboardToolbar;
    currentTextField = textField;

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
    
}
#pragma mark- LZKeyboardToolBarDelegate
-(void)toolbarKeyboardDone
{
    [self.currentTextField resignFirstResponder];
}

- (void)viewDidUnload {
    [self setPersonsBackImageView:nil];
    [self setDaysBackImageView:nil];
    [self setTipsLabel:nil];
    [super viewDidUnload];
}
@end
