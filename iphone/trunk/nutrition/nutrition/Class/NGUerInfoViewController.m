//
//  NGUerInfoViewController.m
//  nutrition
//
//  Created by liu miao on 11/25/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGUerInfoViewController.h"
#import "LZKeyboardToolBar.h"
#import "LZConstants.h"
#import "LZUtility.h"
#import "LZReviewAppManager.h"
#import <math.h>
#import <MessageUI/MessageUI.h>

@interface NGUerInfoViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,LZKeyboardToolBarDelegate, MFMailComposeViewControllerDelegate>
{
    BOOL isChinese;
}
@property (nonatomic,strong)UITextField *currentTextField;
@property (strong,nonatomic) NSNumber *currentHeight;
@property (strong,nonatomic) NSNumber *currentWeight;
@property (strong,nonatomic) NSDate *currentDate;
@end

@implementation NGUerInfoViewController
@synthesize birthdayPicker,heightPicker,currentTextField,currentDate,currentHeight,currentWeight,isPresented;
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
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    [self.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.backView.layer setBorderWidth:0.5f];
    self.birthdayLabel.text = NSLocalizedString(@"xinxi_c_shengri", @"生日项标题：生日");
    self.heightLabel.text = NSLocalizedString(@"xinxi_c_shengao", @"身高项标题：身高");
    self.sexLabel.text = NSLocalizedString(@"xinxi_c_xingbie", @"性别项标题：性别");
    self.weightLabel.text = NSLocalizedString(@"xinxi_c_tizhong", @"体重项标题：体重");
    self.activityLabel.text = NSLocalizedString(@"xinxi_c_huodongqiangdu", @"活动强度项标题：活动强度");
    
    [self.reviewAppButton setTitle:NSLocalizedString(@"settings_pingfenbutton",@"给我们评分") forState:UIControlStateNormal];
    [self.feedbackButton setTitle:NSLocalizedString(@"settings_fankuibutton",@"意见反馈") forState:UIControlStateNormal];
    
    NSString * Key_IsAlreadyReviewdeOurApp = [LZUtility getPersistKey_ByEachVersion_IsAlreadyReviewdeOurApp];
    BOOL alreadyReviewed = [[NSUserDefaults standardUserDefaults]boolForKey:Key_IsAlreadyReviewdeOurApp];
    if (!alreadyReviewed){
        self.feedbackButton.hidden = true;
    }else{
        self.feedbackButton.hidden = false;
    }
    

    self.title = NSLocalizedString(@"xinxi_c_title", @"页面标题：信息");
    self.birthdayPicker = [[UIDatePicker alloc]init];
    self.birthdayPicker.datePickerMode = UIDatePickerModeDate;
    self.heightPicker = [[UIPickerView alloc]init];
    self.heightPicker.showsSelectionIndicator = YES;
    self.heightPicker.delegate = self;
    self.heightPicker.dataSource = self;
    
    if([LZUtility isCurrentLanguageChinese])
    {
        isChinese = YES;
        self.weightUnitLabel.text = @"kg";
        [self.birthdayPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh"]];
    }
    else
    {
        isChinese = NO;
        self.weightUnitLabel.text = @"lb";
        [self.birthdayPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en"]];
    }
    [self.birthdayPicker setMaximumDate:[LZUtility dateBeforeTodayForYears:1]];
    [self.birthdayPicker addTarget:self action:@selector(datepickerChanged) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"xinxi_c_baocun",@"保存按钮：保存") style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    if (!isPresented)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    [self.listView setContentSize:CGSizeMake(320, 535)];
    //[self displayUserInfo];
    
	// Do any additional setup after loading the view.
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [self.listView setContentSize:self.view.bounds.size];
//}
-(void)datepickerChanged
{
    //NSLog(@"value changed");
    self.currentDate = self.birthdayPicker.date;
    if (currentDate == nil)
    {
        self.birthdayTextField.text = @"";
    }
    else
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] init]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.birthdayTextField.text = [formatter stringFromDate:currentDate];
    }

    
}
-(void)displayUserInfo
{
    NSArray *levelArray = [[LZUtility getActivityLevelInfo]objectForKey:@"levelArray"];
    [self.sexSegmentControll setTitle:NSLocalizedString(@"xinxi_c_nan", @"性别男：男") forSegmentAtIndex:0];
    [self.sexSegmentControll setTitle:NSLocalizedString(@"xinxi_c_nv", @"性别女：女") forSegmentAtIndex:1];
    [self.activitySegmentControll setTitle:[levelArray objectAtIndex:0] forSegmentAtIndex:0];
    [self.activitySegmentControll setTitle:[levelArray objectAtIndex:1] forSegmentAtIndex:1];
    [self.activitySegmentControll setTitle:[levelArray objectAtIndex:2] forSegmentAtIndex:2];
    [self.activitySegmentControll setTitle:[levelArray objectAtIndex:3] forSegmentAtIndex:3];
    if (isChinese)
    {
        for (int i =0; i<4; i++)
        {
            [self.activitySegmentControll setWidth:52 forSegmentAtIndex:i];
        }
    }
        NSNumber *userSex = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserSexKey];
    [self.sexSegmentControll setSelectedSegmentIndex:[userSex intValue]];
    [self displayActivityLevelDiscription];
    NSNumber *userActivityLevel = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserActivityLevelKey];
    currentDate = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserBirthKey];
    [self.activitySegmentControll setSelectedSegmentIndex:[userActivityLevel intValue]];
    currentWeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserWeightKey];
    if (currentWeight == nil)
    {
        self.weightTextField.text = @"";
    }
    else
    {
        
        if (isChinese)
        {
            self.weightTextField.text = [NSString stringWithFormat:@"%@",[LZUtility getAccurateStringWithDecimal:[currentWeight doubleValue]]];
        }
        else
        {
            double covertedWeight =round([currentWeight doubleValue]*kKGConvertLBRatio);
            self.weightTextField.text = [NSString stringWithFormat:@"%@",[LZUtility getAccurateStringWithDecimal:covertedWeight]];
        }
        CGSize weightSize = [self.weightTextField.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 40)];
        CGRect weightFrame = self.weightTextField.frame;
        weightFrame.size.width = weightSize.width;
        self.weightTextField.frame = weightFrame;
        CGRect weightLabelFrame =  self.weightUnitLabel.frame;
        weightLabelFrame.origin.x = weightFrame.origin.x + weightFrame.size.width+1;
        self.weightUnitLabel.frame = weightLabelFrame;
        
    }
    if (currentDate == nil)
    {
        self.birthdayTextField.text = @"";
    }
    else
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] init]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.birthdayTextField.text = [formatter stringFromDate:currentDate];
    }
    
    currentHeight = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserHeightKey];
    if (currentHeight == nil)
    {
        self.heightTextField.text = @"";
    }
    else
    {
        if (isChinese)
        {
            self.heightTextField.text = [NSString stringWithFormat:@"%dcm",[currentHeight intValue]];
        }
        else
        {
            self.heightTextField.text = [LZUtility convertIntToInch:[currentHeight intValue]];
        }
    }
    if (!isPresented)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}
-(void)saveButtonTapped
{
    if (self.currentTextField != nil)
    {
        [self.currentTextField resignFirstResponder];
    }
    if (self.currentDate != nil)
    {
        int userAge = [LZUtility calculateAgeAccordingToTheBirthdate:self.currentDate];
        //NSLog(@"%d",userAge);
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:userAge] forKey:LZUserAgeKey];
        [[NSUserDefaults standardUserDefaults]setObject:self.currentDate forKey:LZUserBirthKey];
    }
    else
    {
        [self alertWithTitle:NSLocalizedString(@"xinxi_m_wenxintishi",@"alert标题：温馨提示") msg:NSLocalizedString(@"xinxi_m_shengricuowu", @"生日错误信息：生日填写错误，请重新填写")];
        return;
    }
    if (currentHeight != nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:currentHeight forKey:LZUserHeightKey];
    }
    else
    {
        [self alertWithTitle:NSLocalizedString(@"xinxi_m_wenxintishi",@"alert标题：温馨提示") msg:NSLocalizedString(@"xinxi_m_shengaocuowu", @"身高错误信息：身高填写错误，请重新填写")];
        return;
    }
    if ([self.weightTextField.text length]!= 0 && [self.weightTextField.text intValue]>0)
    {
        double userWeight = [self.weightTextField.text doubleValue];
        if (isChinese)
        {
            if (userWeight > 999)
            {
                [self alertWithTitle:NSLocalizedString(@"xinxi_m_wenxintishi",@"alert标题：温馨提示") msg:NSLocalizedString(@"xinxi_m_tizhongcuowu", @"体重错误信息：体重填写错误，请重新填写")];
                return;
            }
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:userWeight] forKey:LZUserWeightKey];
        }
        else
        {
            double convertedWeight = (double)(userWeight/kKGConvertLBRatio);
            if (convertedWeight > 999)
            {
                [self alertWithTitle:NSLocalizedString(@"xinxi_m_wenxintishi",@"alert标题：温馨提示") msg:NSLocalizedString(@"xinxi_m_tizhongcuowu", @"体重错误信息：体重填写错误，请重新填写")];
                return;
            }
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:convertedWeight] forKey:LZUserWeightKey];
        }
    }
    else
    {
        [self alertWithTitle:NSLocalizedString(@"xinxi_m_wenxintishi",@"alert标题：温馨提示") msg:NSLocalizedString(@"xinxi_m_tizhongcuowu", @"体重错误信息：体重填写错误，请重新填写")];
        return;
    }
    NSNumber *sexNumber = [NSNumber numberWithInt:[self.sexSegmentControll selectedSegmentIndex]];
    [[NSUserDefaults standardUserDefaults]setObject:sexNumber forKey:LZUserSexKey];
    NSNumber *activityNumber = [NSNumber numberWithInt:[self.activitySegmentControll selectedSegmentIndex]];
    [[NSUserDefaults standardUserDefaults]setObject:activityNumber forKey:LZUserActivityLevelKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_SettingsChangedKey object:nil];
    if (isPresented)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self displayUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    //    [MobClick endLogPageView:UmengPathGeRenXinXi];
}
-(void)displayActivityLevelDiscription
{
    int selected = [self.activitySegmentControll selectedSegmentIndex];
    NSArray *levelArray = [[LZUtility getActivityLevelInfo]objectForKey:@"levelArray"];
    NSDictionary *levelDes = [[LZUtility getActivityLevelInfo]objectForKey:@"levelDescription"];
    NSString *currentLevel = [levelArray objectAtIndex:selected];
    NSString *currentDes = [levelDes objectForKey:currentLevel];
    CGSize descriptionSize = [currentDes sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(210, 9999) lineBreakMode:UILineBreakModeWordWrap];
    NSString *onlineStr = @"1";
    CGSize onlineSize = [onlineStr sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(210, 9999) lineBreakMode:UILineBreakModeWordWrap];
    float onelineHeight = onlineSize.height;
    float desHeight = descriptionSize.height;
    if (desHeight > onelineHeight)
    {
        self.activityDescriptionLabel.textAlignment = UITextAlignmentLeft;
    }
    else
    {
        self.activityDescriptionLabel.textAlignment = UITextAlignmentCenter;
    }
    CGRect labelFrame = self.activityDescriptionLabel.frame;
    labelFrame.size.height = descriptionSize.height;
    self.activityDescriptionLabel.frame = labelFrame;
    self.activityDescriptionLabel.text = currentDes;

}
- (IBAction)sexChanged:(id)sender {
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}
- (IBAction)activityChanged:(id)sender
{
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self displayActivityLevelDiscription];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)keyboardWillShow:(NSNotification *)notification {
	
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *boundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [boundsValue CGRectValue];
    float tabbarHeight = 49;
    if (isPresented)
    {
        tabbarHeight = 0;
    }

    CGFloat keyboardTop = self.view.frame.size.height - keyboardRect.size.height+tabbarHeight;
    CGRect tableviewFrame = self.listView.frame;
	tableviewFrame.size.height = keyboardTop;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
	CGRect tableviewFrame = self.listView.frame;
	tableviewFrame.size.height = self.view.frame.size.height;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];
    
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

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isChinese)
    {
        if (component == 0)
        {
            return 300;
        }
        return 1;
    }
    else
    {
        if (component == 0)
        {
            return 9;
        }
        else
        {
            return 12;
        }
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (isChinese)
    {
        if (component == 0)
        {
            return [NSString stringWithFormat:@"%d",row];
        }
        return @"cm";
    }
    else
    {
        if (component == 0)
        {
            return [NSString stringWithFormat:@"%d'",row];
        }
        return [NSString stringWithFormat:@"%d''",row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isChinese)
    {
        if (component == 0)
        {
            self.currentHeight = [NSNumber numberWithInt:row];
            self.heightTextField.text = [NSString stringWithFormat:@"%dcm",[currentHeight intValue]];
        }
    }
    else
    {
        int feet =[pickerView selectedRowInComponent:0];
        int inch = [pickerView selectedRowInComponent:1];
        self.heightTextField.text = [NSString stringWithFormat:@"%d' %d''",feet,inch];
        self.currentHeight = [NSNumber numberWithInt:[self calculateHeightForFeet:feet inch:inch]];
    }
}
-(int)calculateHeightForFeet:(int)feet inch:(int)inch
{
    int height = feet * 30.48+ inch*2.54;
    return height;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    LZKeyboardToolBar *keyboardToolbar = [[LZKeyboardToolBar alloc]initWithFrame:kKeyBoardToolBarRect doneButtonTitle:NSLocalizedString(@"wanchengbutton",@"完成") delegate:self];
    if (textField == self.birthdayTextField)
    {
        if (currentDate)
        {
            [self.birthdayPicker setDate:currentDate];
        }
        else
        {
            self.currentDate =[LZUtility dateBeforeTodayForYears:25];
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] init]];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            self.birthdayTextField.text = [formatter stringFromDate:currentDate];
            [self.birthdayPicker setDate:[LZUtility dateBeforeTodayForYears:25]];
        }
        textField.inputView = self.birthdayPicker;
    }
    else if (textField == self.heightTextField)
    {
        if (currentHeight)
        {
            if (isChinese)
            {
                [self.heightPicker selectRow:[currentHeight intValue] inComponent:0 animated:NO];
            }
            else
            {
                int total = ([currentHeight intValue]*100)/2.54;
                int feet = total/1200;
                int inch = ((total%1200))/100;
                [self.heightPicker selectRow:feet inComponent:0 animated:NO];
                [self.heightPicker selectRow:inch inComponent:1 animated:NO];
            }
        }
        else
        {
            if (isChinese)
            {
                self.currentHeight = [NSNumber numberWithInt:170];
                self.heightTextField.text = [NSString stringWithFormat:@"%dcm",170];
                [self.heightPicker selectRow:170 inComponent:0 animated:NO];
            }
            else
            {
                self.currentHeight = [NSNumber numberWithInt:170];
                int total = ([currentHeight intValue]*100)/2.54;
                int feet = total/1200;
                int inch = ((total%1200))/100;
                [self.heightPicker selectRow:feet inComponent:0 animated:NO];
                [self.heightPicker selectRow:inch inComponent:1 animated:NO];
                self.heightTextField.text = [LZUtility convertIntToInch:[currentHeight intValue] ];
            }

        }
        textField.inputView = self.heightPicker;
        
    }
    textField.inputAccessoryView = keyboardToolbar;
    self.currentTextField = textField;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //        if (tag == 200)
    //        {
    //            [self.listView setContentOffset:CGPointMake(0, 55) animated:YES];
    //        }
    //        else if (tag == 201)
    //        {
    //            [self.listView setContentOffset:CGPointMake(0, 105) animated:YES];
    //        }
    //        else if (tag == 202)
    //        {
    //            [self.listView setContentOffset:CGPointMake(0, 155) animated:YES];
    //        }
    
    //    });
    
    //[textField becomeFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.currentTextField = nil;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.birthdayTextField || textField == self.heightTextField)
        return NO;
    else
        return YES;
//    NSCharacterSet *cs;
//    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
//    NSString *filtered =
//    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    BOOL basic = [string isEqualToString:filtered];
//    if (basic)
//    {
//        if ([string length]+[textField.text length]>5)
//        {
//            return NO;
//        }
//        else
//        {
//            return YES;
//        }
//    }
//    else {
//        return NO;
//    }
    
}
- (IBAction)birthdayButtonClicked:(id)sender {
//    if (self.currentTextField == nil || self.currentTextField!= self.birthdayTextField)
//    {
        [self.birthdayTextField becomeFirstResponder];
//    }
}
- (IBAction)heightButtonClicked:(id)sender {
//    if (self.currentTextField == nil || self.currentTextField!= self.heightTextField)
//    {
        [self.heightTextField becomeFirstResponder];
 //   }
}
- (IBAction)weightButtonClicked:(id)sender {
//    if (self.currentTextField == nil || self.currentTextField!= self.weightTextField)
//    {
        [self.weightTextField becomeFirstResponder];
 //   }
}

#pragma mark- LZKeyboardToolBarDelegate
-(void)toolbarKeyboardDone
{
    if(self.currentTextField)
    {
        [self.currentTextField resignFirstResponder];
    }
}

- (IBAction)btnReviewClicked:(id)sender {
    [[LZReviewAppManager SharedInstance]reviewOurAppDirectly];
    self.feedbackButton.hidden = false;
}
- (IBAction)btnFeedbackClicked:(id)sender {
    [self performSelector:@selector(feedbackAction) withObject:nil afterDelay:0.f];
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
            [self alertWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") msg:NSLocalizedString(@"settings_alert1_message",@"你还没有邮件账户，请到系统设置里面创建一个")];
        }
    }
    
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: NSLocalizedString(@"settings_email_title",@"用户意见反馈")];
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}







@end















