//
//  LZAnalysislViewController.m
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZAnalysislViewController.h"
#import "LZConstants.h"
#import "LZRecommendFood.h"
#import <MessageUI/MessageUI.h>



@interface LZAnalysislViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation LZAnalysislViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}
- (IBAction)emailButtonTapped:(id)sender {
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
    [mailPicker setSubject: @"营养推荐反馈"];
    
    //添加发送者
    NSArray *toRecipients = [NSArray arrayWithObjects: @"xinru.zong@yasofon.com",@"lianyu.zhang@yasofon.com",@"dalei.li@yasofon.com",@"miao.liu@yasofon.com",nil];

    [mailPicker setToRecipients: toRecipients];

    
    if (csvFilePath != nil){
        NSData *attachmentData = [NSData dataWithContentsOfFile:csvFilePath];
        [mailPicker addAttachmentData:attachmentData mimeType: @"text/csv" fileName: @"report.csv"];
    }
       
    //设置正文
//    //NSString *emailBody = self.recommendTextView.text;
//    NSString *emailBody = txtCalculateInfo;
//    [mailPicker setMessageBody:emailBody isHTML:NO];
    NSString *emailBody = htmlCalculateInfo;
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
    
    
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

//UIAlertViewDelegate Protocol Reference
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:LZUserWeightKey]==nil){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"缺少用户信息", @"") message:@"请先填写用户信息" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
//    float weight = [userDefaults floatForKey:LZUserWeightKey];
//    float height = [userDefaults floatForKey:LZUserHeightKey];
//    int age = [userDefaults floatForKey:LZUserAgeKey];
//    int sex = [userDefaults floatForKey:LZUserSexKey];
//    int activityLevel = [userDefaults floatForKey:LZUserActivityLevelKey];
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
//                              [NSNumber numberWithInt:age],@"age", [NSNumber numberWithInt:sex],@"sex",
//                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    
    NSDictionary *dailyIntake = [userDefaults objectForKey:LZUserDailyIntakeKey];
    
    BOOL notAllowSameFood = TRUE;//这是一个策略标志位，偏好食物的多样化的标志位，即当选取食物补充营养时，优先选取以前没有用过的食物。
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 2;//配合randomSelectFood，用于限制随机范围，0表示不限制, >0表示优先选择其范围内的东西
    BOOL needLimitNutrients = TRUE;//是否要根据需求限制计算的营养素集合
    int limitRecommendFoodCount = 4;//0;//4;//只限制显示的
    
    if ( [userDefaults objectForKey:LZSettingKey_randomSelectFood]!=nil ){
        randomSelectFood = [userDefaults boolForKey:LZSettingKey_randomSelectFood];
    }
    if ( [userDefaults objectForKey:LZSettingKey_randomRangeSelectFood]!=nil ){
        randomRangeSelectFood = [userDefaults integerForKey:LZSettingKey_randomRangeSelectFood];
    }
    if ( [userDefaults objectForKey:LZSettingKey_needLimitNutrients]!=nil ){
        needLimitNutrients = [userDefaults boolForKey:LZSettingKey_needLimitNutrients];
    }
    if ( [userDefaults objectForKey:LZSettingKey_notAllowSameFood]!=nil ){
        notAllowSameFood = [userDefaults boolForKey:LZSettingKey_notAllowSameFood];
    }
    if ( [userDefaults objectForKey:LZSettingKey_limitRecommendFoodCount]!=nil ){
        limitRecommendFoodCount = [userDefaults integerForKey:LZSettingKey_limitRecommendFoodCount];
    }
    
    uint personCount = 1;
    uint dayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount", nil];

    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             nil];
    //NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:dailyIntake andUserInfo:userInfo andOptions:options];
    NSMutableDictionary *retDict = [rf recommendFood2_AbstractPerson:params withDecidedFoods:dailyIntake andOptions:options];
    NSArray * ary2D = [rf generateData2D_RecommendFoodForEnoughNuitrition:retDict];
    NSString * detailStr = [rf convert2DArrayToText:ary2D];
    txtCalculateInfo = detailStr;
    //self.recommendTextView.text = detailStr;
    
    NSString * filePath = [LZUtility convert2DArrayToCsv:@"recommend1.csv" withData:ary2D];
    csvFilePath = filePath;
//    NSURL *csvFileUrl = [NSURL fileURLWithPath:csvFilePath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:csvFileUrl];
//    [self.recommendWebViewAsTable loadRequest:request];

    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    htmlCalculateInfo = strHtml;
    NSString * sBaseURL = @"localhost";
    NSURL *baseURL = [NSURL URLWithString:sBaseURL];
    [self.recommendWebViewAsTable loadHTMLString:strHtml baseURL:baseURL];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:@"recommend1.html"];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
