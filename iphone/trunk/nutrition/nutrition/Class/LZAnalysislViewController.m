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
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    assert([[NSUserDefaults standardUserDefaults] objectForKey:LZUserWeightKey]!=nil);
        
    float weight = [[NSUserDefaults standardUserDefaults] floatForKey:LZUserWeightKey];
    float height = [[NSUserDefaults standardUserDefaults] floatForKey:LZUserHeightKey];
    int age = [[NSUserDefaults standardUserDefaults] floatForKey:LZUserAgeKey];
    int sex = [[NSUserDefaults standardUserDefaults] floatForKey:LZUserSexKey];
    int activityLevel = [[NSUserDefaults standardUserDefaults] floatForKey:LZUserActivityLevelKey];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:age],@"age", [NSNumber numberWithInt:sex],@"sex",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    
    NSDictionary *dailyIntake = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:dailyIntake andUserInfo:userInfo andOptions:nil];
    NSArray * ary2D = [rf generateData2D_RecommendFoodForEnoughNuitrition:retDict];
    NSString * detailStr = [rf convert2DArrayToText:ary2D];
    txtCalculateInfo = detailStr;
    //self.recommendTextView.text = detailStr;
    
    NSString * filePath = [rf convert2DArrayToCsv:@"recommend1.csv" withData:ary2D];
    csvFilePath = filePath;
//    NSURL *csvFileUrl = [NSURL fileURLWithPath:csvFilePath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:csvFileUrl];
//    [self.recommendWebViewAsTable loadRequest:request];

    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    htmlCalculateInfo = strHtml;
    NSString * sBaseURL = @"localhost";
    NSURL *baseURL = [NSURL URLWithString:sBaseURL];
    [self.recommendWebViewAsTable loadHTMLString:strHtml baseURL:baseURL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
