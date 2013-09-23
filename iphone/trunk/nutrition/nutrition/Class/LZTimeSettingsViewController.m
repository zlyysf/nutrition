//
//  LZTimeSettingsViewController.m
//  nutrition
//
//  Created by liu miao on 9/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZTimeSettingsViewController.h"
#import "LZConstants.h"
#import "LZUtility.h"
@interface LZTimeSettingsViewController ()
@property (nonatomic,strong)NSDate *shangwuDate;
@property (nonatomic,strong)NSDate *xiawuDate;
@property (nonatomic,strong)NSDate *shuiqianDate;
@property (nonatomic,strong)UITextField *currentDisplayField;
@property (nonatomic,strong)NSNumber *reminderState;
@property (nonatomic,strong)UIDatePicker *datePicker;
@end

@implementation LZTimeSettingsViewController

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
    self.title = @"诊断提醒";
    UIImage *originBg = [UIImage imageNamed:@"outer_line_bg.png"];
    UIImage *outerBg = [originBg stretchableImageWithLeftCapWidth:6 topCapHeight:6];
    [self.outBoundImageView setImage:outerBg];
    [self.line1View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line2View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line3View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveItemTapped)];
    self.navigationItem.rightBarButtonItem = saveItem;
    self.datePicker = [[UIDatePicker alloc]init];
    [self.datePicker setDatePickerMode:UIDatePickerModeTime];
    [self.datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"]];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    self.reminderState = [[NSUserDefaults standardUserDefaults]objectForKey:KeyHealthCheckReminderState];
    if ([self.reminderState boolValue])
    {
        [self.reminderStateSwitch setOn:YES];
    }
    else
    {
        [self.reminderStateSwitch setOn:NO];
    }
    NSDate *shangwuDateDefault = [[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderShangWu];
    NSDate *xiawuDateDeFault = [[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderXiaWu];
    NSDate *shuiqianDateDefault = [[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderShuiQian];
    self.shangwuDate = [LZUtility convertOldDateToTodayDate:shangwuDateDefault];
    self.xiawuDate = [LZUtility convertOldDateToTodayDate:xiawuDateDeFault];
    self.shuiqianDate = [LZUtility convertOldDateToTodayDate:shuiqianDateDefault];
    self.shangwuTextField.text = [LZUtility getDateFormatOutput:self.shangwuDate];
    self.xiawuTextField.text = [LZUtility getDateFormatOutput:self.xiawuDate];
    self.shuiqianTextField.text = [LZUtility getDateFormatOutput:self.shuiqianDate];
	// Do any additional setup after loading the view.
    [self.shangwuTextField becomeFirstResponder];
}
-(void)displayDate:(NSDate*)date
{
    [self.datePicker setDate:date animated:YES];
}
-(void)saveItemTapped
{
    [[NSUserDefaults standardUserDefaults]setObject:self.reminderState forKey:KeyHealthCheckReminderState];
    [[NSUserDefaults standardUserDefaults]setObject:self.shangwuDate forKey:KeyCheckReminderShangWu];
    [[NSUserDefaults standardUserDefaults]setObject:self.xiawuDate forKey:KeyCheckReminderXiaWu];
    [[NSUserDefaults standardUserDefaults]setObject:self.shuiqianDate forKey:KeyCheckReminderShuiQian];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [LZUtility setCheckReminderOn:[self.reminderState boolValue]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shanwuButtonClicked:(id)sender {
    [self.shangwuTextField becomeFirstResponder];
}
- (IBAction)xiawuButtonClicked:(id)sender {
    [self.xiawuTextField becomeFirstResponder];
}
- (IBAction)shuiqianButtonClicked:(id)sender {
    [self.shuiqianTextField becomeFirstResponder];
}
-(void)datePickerValueChanged
{
    if (self.currentDisplayField)
    {
        NSDate *date = self.datePicker.date;
        if (self.currentDisplayField == self.shangwuTextField)
        {
            self.shangwuDate = self.datePicker.date;
        }
        else if(self.currentDisplayField == self.xiawuTextField)
        {
            self.xiawuDate = self.datePicker.date;
        }
        else
        {
            self.shuiqianDate = self.datePicker.date;
        }
        self.currentDisplayField.text = [LZUtility getDateFormatOutput:date];
    }
}
- (IBAction)switchChanged:(id)sender {
    BOOL state = self.reminderStateSwitch.isOn;
    self.reminderState  = [NSNumber numberWithBool:state];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.shangwuTextField)
    {
        NSDate *minDate = [LZUtility getDateForHour:6 Minutes:0];
        NSDate *maxDate = [LZUtility getDateForHour:11 Minutes:59];
        [self.datePicker setMinimumDate:minDate];
        [self.datePicker setMaximumDate:maxDate];
        [self displayDate:self.shangwuDate];
    }
    else if (textField == self.xiawuTextField)
    {
        NSDate *minDate = [LZUtility getDateForHour:12 Minutes:0];
        NSDate *maxDate = [LZUtility getDateForHour:18 Minutes:59];
        [self.datePicker setMinimumDate:minDate];
        [self.datePicker setMaximumDate:maxDate];
        [self displayDate:self.xiawuDate];
    }
    else
    {
        NSDate *minDate = [LZUtility getDateForHour:19 Minutes:0];
        NSDate *maxDate = [LZUtility getDateForHour:24 Minutes:0];
        [self.datePicker setMinimumDate:minDate];
        [self.datePicker setMaximumDate:maxDate];
        [self displayDate:self.shuiqianDate];
    }
    textField.inputView = self.datePicker;
    self.currentDisplayField = textField;
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
}// return NO to disallow editing.
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField == self.shangwuTextField)
//    {
//    }
//    else if (textField == self.xiawuTextField)
//    {
//    }
//    else
//    {
//        
//    }
//
//}// became first responder
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField == self.shangwuTextField)
//    {
//    }
//    else if (textField == self.xiawuTextField)
//    {
//    }
//    else
//    {
//        
//    }
//
//}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;

}// return NO to not change text
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.shangwuTextField)
    {
    }
    else if (textField == self.xiawuTextField)
    {
    }
    else
    {
        
    }
    return YES;
}// called when 'return' key pressed. return NO to ignore.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setShangwuTextField:nil];
    [self setReminderStateSwitch:nil];
    [self setXiawuTextField:nil];
    [self setShuiqianTextField:nil];
    [self setLine1View:nil];
    [self setLine2View:nil];
    [self setLine3View:nil];
    [self setOutBoundImageView:nil];
    [super viewDidUnload];
}
@end
