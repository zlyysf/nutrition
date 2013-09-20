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
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveItemTapped)];
    self.navigationItem.rightBarButtonItem = saveItem;
    [self.datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"]];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setMinuteInterval:5];
    NSNumber *state = [[NSUserDefaults standardUserDefaults]objectForKey:KeyHealthCheckReminderState];
    if ([state boolValue])
    {
        [self.reminderStateSwitch setOn:YES];
    }
    else
    {
        [self.reminderStateSwitch setOn:NO];
    }
    NSDate *shangwuDate = [[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderShangWu];
    NSDate *xiawuDate = [[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderXiaWu];
    NSDate *shuiqianDate = [[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderShuiQian];
    self.shangwuTextField.text = [LZUtility getDateFormatOutput:shangwuDate];
    self.xiawuTextField.text = [LZUtility getDateFormatOutput:xiawuDate];
    self.shuiqianTextField.text = [LZUtility getDateFormatOutput:shuiqianDate];
	// Do any additional setup after loading the view.
}
-(void)saveItemTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)datePickerValueChanged
{
    self.shangwuTextField.text = [LZUtility getDateFormatOutput:self.datePicker.date];
    
}
- (IBAction)switchChanged:(id)sender {
    BOOL state = self.reminderStateSwitch.isOn;
    if (state)
    {
        
    }
    else
    {
        
    }
    NSNumber *newState = [NSNumber numberWithBool:state];
    [[NSUserDefaults standardUserDefaults]setObject:newState forKey:KeyHealthCheckReminderState];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
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
    textField.inputView = self.datePicker;
    return YES;
}// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField
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

}// became first responder
- (void)textFieldDidEndEditing:(UITextField *)textField
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

}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
    if (textField == self.shangwuTextField)
    {
    }
    else if (textField == self.xiawuTextField)
    {
    }
    else
    {
        
    }

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

}// called when 'return' key pressed. return NO to ignore.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDatePicker:nil];
    [self setShangwuTextField:nil];
    [self setReminderStateSwitch:nil];
    [self setXiawuTextField:nil];
    [self setShuiqianTextField:nil];
    [super viewDidUnload];
}
@end
