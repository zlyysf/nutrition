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
#import "GADMasterViewController.h"
@interface LZSettingsViewController ()<LZKeyboardToolBarDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@end

@implementation LZSettingsViewController
@synthesize currentTextField;
@synthesize topSectionView;
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
    self.topSectionView.hidden = YES;
    UIImage *greenButtonImage = [UIImage imageNamed:@"green_button.png"];
    [self.line1View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line2View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.resetButton setBackgroundImage:greenButtonImage forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:greenButtonImage forState:UIControlStateNormal];
    if ([[UIScreen mainScreen] bounds].size.height == 568)//iphone 5
    {
        [self.contentScrollView setContentSize:CGSizeMake(320, 455)];
    }
    else
    {
        [self.contentScrollView setContentSize:CGSizeMake(320, 367)];
    }
//    [ShareSDK addNotificationWithName:SSN_USER_AUTH
//                               target:self
//                               action:@selector(userInfoUpdateHandler:)];
	// Do any additional setup after loading the view.
    //显示目前设定的人数 天数
 }
- (IBAction)authSwitchChangeHandler:(UISwitch *)sender
{
    if (sender.on)
    {
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"买菜助手"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        //[ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"ShareSDK"],
                                        //SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];
        [ShareSDK authWithType:ShareTypeSinaWeibo options:authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
            if (state == SSAuthStateCancel || state == SSAuthStateFail)
            {
                [self.weiboAuthSwitch setOn:NO];
            }
            NSLog(@"ssauthState %d",state);
        }];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"解除新浪微博绑定？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解除", nil];//[ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//0
    {
        //现在就评分
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    }
    else
    {
        [self.weiboAuthSwitch setOn:YES];
    }
    
}

//- (void)userInfoUpdateHandler:(NSNotification *)notif
//{
//    NSLog(@"notify user info %@",[notif userInfo]);
//}
- (void)viewWillAppear:(BOOL)animated
{
    self.weiboAuthSwitch.on = [ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];

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
    if ([[UIScreen mainScreen] bounds].size.height == 568)//iphone 5
    {
//        CGRect topFrame = self.topSectionView.frame;
//        topFrame.origin.y = 30;
//        self.topSectionView.frame = topFrame;
        
        CGRect midFrame = self.midSectionView.frame;
        midFrame.origin.y = 30;//214
        self.midSectionView.frame = midFrame;
        
        CGRect bottomFrame = self.bottomSectionView.frame;
        bottomFrame.origin.y = 130;//325
        self.bottomSectionView.frame = bottomFrame;
        
        CGRect mobFrame = self.admobView.frame;
        mobFrame.origin.y = 405;
        self.admobView.frame = mobFrame;
    }
    else
    {
//        CGRect topFrame = self.topSectionView.frame;
//        topFrame.origin.y = 10;
//        self.topSectionView.frame = topFrame;
        
        CGRect midFrame = self.midSectionView.frame;
        midFrame.origin.y = 30;//174
        self.midSectionView.frame = midFrame;
        
        CGRect bottomFrame = self.bottomSectionView.frame;
        bottomFrame.origin.y = 130;//265
        self.bottomSectionView.frame = bottomFrame;
        
        CGRect mobFrame = self.admobView.frame;
        mobFrame.origin.y = 317;
        self.admobView.frame = mobFrame;
    }
}
- (IBAction)reviewOurApp:(id)sender {

    [[LZReviewAppManager SharedInstance]reviewOurAppDirectly];
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
    [self setContentScrollView:nil];
    [self setWeiboAuthSwitch:nil];
    [self setAdmobView:nil];
    [self setTopSectionView:nil];
    [self setResetButton:nil];
    [self setSaveButton:nil];
    [self setMidSectionView:nil];
    [self setBottomSectionView:nil];
    [self setLine1View:nil];
    [self setLine2View:nil];
    [super viewDidUnload];
}
@end
