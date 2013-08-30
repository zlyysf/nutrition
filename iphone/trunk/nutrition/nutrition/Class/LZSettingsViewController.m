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
#import "MobClick.h"
#import "LZUtility.h"
#import "LZEditProfileViewController.h"
#import "LZDebugSettingsViewController.h"
@interface LZSettingsViewController ()<LZKeyboardToolBarDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@end

@implementation LZSettingsViewController
@synthesize currentTextField;
@synthesize topSectionView;
@synthesize baiduAdWall;
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
//    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setTitle:@"  返回" forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 0, 48, 30);
//    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
//    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = backItem;
    UIImage *textImage = [UIImage imageNamed:@"setting_cell_back.png"];
    UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    [self.personsBackImageView setImage:textBackImage];
    [self.editProfileButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [self.line1View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line2View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line3View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line4View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line5View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    if ([LZUtility isIphoneDeviceVersionFive])//iphone 5
    {
        [self.contentScrollView setContentSize:CGSizeMake(320, 454)];
    }
    else
    {
        [self.contentScrollView setContentSize:CGSizeMake(320, 399)];
    }
    self.baiduAdWall = [[BaiduMobAdWall alloc] init];
    self.baiduAdWall.delegate = self;

 }
-(void)backButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
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
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"营养膳食指南"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        //[ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"ShareSDK"],
                                        //SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];
        [ShareSDK authWithType:ShareTypeSinaWeibo options:authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
            if (state == SSAuthStateCancel || state == SSAuthStateFail)
            {
                [self.weiboAuthSwitch setOn:NO];
            }
            //NSLog(@"ssauthState %d",state);
        }];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"解除新浪微博绑定？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解除", nil];//[ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
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

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"设置页面"];
    self.weiboAuthSwitch.on = [ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];

    CGRect topFrame = self.topSectionView.frame;
    topFrame.origin.y = 10;
    self.topSectionView.frame = topFrame;
    
    CGRect midFrame = self.midSectionView.frame;
    midFrame.origin.y = 180;
    self.midSectionView.frame = midFrame;
    
    CGRect bottomFrame = self.bottomSectionView.frame;
    bottomFrame.origin.y = 320;
    self.bottomSectionView.frame = bottomFrame;

//    if ([[UIScreen mainScreen] bounds].size.height == 568)//iphone 5
//    {
//         
//        CGRect mobFrame = self.admobView.frame;
//        mobFrame.origin.y = 454;
//        self.admobView.frame = mobFrame;
//    }
//    else
//    {
//        CGRect mobFrame = self.admobView.frame;
//        mobFrame.origin.y = 406;
//        self.admobView.frame = mobFrame;
//    }
    NSNumber *userSex = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserSexKey];
    NSNumber *userAge = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserAgeKey];
    NSNumber *userHeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserHeightKey];
    NSNumber *userWeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserWeightKey];
    NSNumber *userActivityLevel = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserActivityLevelKey];
    self.userSexLabel.text = ([userSex intValue] == 0 ? [NSString stringWithFormat:@"%@",@"男"]:[NSString stringWithFormat:@"%@",@"女"]);
    self.userAgeLabel.text = [NSString stringWithFormat:@"%d岁",[userAge intValue]];
    self.userHeightLabel.text = [NSString stringWithFormat:@"%dcm",[userHeight intValue]];
    self.userWeightLabel.text = [NSString stringWithFormat:@"%dkg",[userWeight intValue]];
    NSString *levelDes = [[[LZUtility getActivityLevelInfo]objectForKey:@"levelArray"]objectAtIndex:[userActivityLevel intValue]];
    self.userActivityLabel.text =levelDes;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"设置页面"];
}
- (IBAction)recommendAppAction:(id)sender
{
    [self.baiduAdWall showOffers];
}
- (IBAction)reviewOurApp:(id)sender {
    [self performSelector:@selector(reviewAppAction) withObject:nil afterDelay:0.f];
}
- (void)reviewAppAction
{
    [[LZReviewAppManager SharedInstance]reviewOurAppDirectly];
}
- (IBAction)userFeedBack:(id)sender {
    if (KeyIsEnvironmentDebug)
    {
        LZDebugSettingsViewController * debugController = [[LZDebugSettingsViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:debugController];
        [self presentModalViewController:nav animated:YES];
    }
    else
    {
        [self performSelector:@selector(feedbackAction) withObject:nil afterDelay:0.f];
    }
}
- (void)feedbackAction
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else{
            [self alertWithTitle:@"温馨提示" msg:@"你还没有邮件账户，请到系统设置里面创建一个"];
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
    NSArray *toRecipients = [NSArray arrayWithObjects: @"support@lingzhimobile.com",nil];
    
    [mailPicker setToRecipients: toRecipients];
    
    [mailPicker setMessageBody:@"" isHTML:NO];
    
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

//- (IBAction)saveChanges:(id)sender
//{
//    [currentTextField resignFirstResponder];
//    int persons = [self.personsTextField.text intValue];
//    int days = [self.daysTextField.text intValue];
//    if (persons <=0 || days <=0 || persons >= 10 || days>= 10)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入合适的数字" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//        [alert show];
//        NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
//        NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
//        if (planPerson != nil)
//        {
//            self.personsTextField.text = [NSString stringWithFormat:@"%d",[planPerson intValue]];
//        }
//        else
//        {
//            self.personsTextField.text = [NSString stringWithFormat:@"%d",1];
//            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanPersonsKey];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        }
//        if (planDays != nil)
//        {
//            self.daysTextField.text = [NSString stringWithFormat:@"%d",[planDays intValue]];
//        }
//        else
//        {
//            self.daysTextField.text = [NSString stringWithFormat:@"%d",1];
//            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanDaysKey];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        }
//        return;
//    }
//    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:days] forKey:LZPlanDaysKey];
//    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:persons] forKey:LZPlanPersonsKey];
//    [[NSUserDefaults standardUserDefaults]synchronize];

//}
- (IBAction)editUserProfile:(id)sender {
    [self performSelector:@selector(editProfileAction) withObject:nil afterDelay:0.f];
}
- (void)editProfileAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZEditProfileViewController *editProfileViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZEditProfileViewController"];
    editProfileViewController.firstEnterEditView = NO;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:editProfileViewController];
    [self presentModalViewController:navController animated:YES];
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
    [self setContentScrollView:nil];
    [self setWeiboAuthSwitch:nil];
    [self setAdmobView:nil];
    [self setTopSectionView:nil];
    [self setMidSectionView:nil];
    [self setBottomSectionView:nil];
    [self setLine2View:nil];
    [self setUserSexLabel:nil];
    [self setUserHeightLabel:nil];
    [self setUserWeightLabel:nil];
    [self setUserActivityLabel:nil];
    [self setUserSexLabel:nil];
    [self setLine1View:nil];
    [self setLine3View:nil];
    [self setLine4View:nil];
    [self setUserAgeLabel:nil];
    [self setEditProfileButton:nil];
    [self setLine5View:nil];
    [super viewDidUnload];
}
#pragma mark BaiduMobAdWallDelegate
- (NSString *)publisherId
{
    return BaiduAdsAppSID;
}


- (NSString*) appSpec
{
    return BaiduAdsAppSpec;
}

@end
