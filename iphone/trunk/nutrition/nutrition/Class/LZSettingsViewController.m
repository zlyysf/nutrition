//
//  LZSettingsViewController.m
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZSettingsViewController.h"
#import "LZConstants.h"
@interface LZSettingsViewController ()

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
    self.tipsLabel.text = @"我们默认向您推荐一个成年人一天的食物量，可以按照实际情况进行适当修改。";
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
- (IBAction)saveChanges:(id)sender
{
    [currentTextField resignFirstResponder];
    int persons = [self.personsTextField.text intValue];
    int days = [self.daysTextField.text intValue];
    if (persons <=0 || days <=0)
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
    currentTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)viewDidUnload {
    [self setPersonsBackImageView:nil];
    [self setDaysBackImageView:nil];
    [self setTipsLabel:nil];
    [super viewDidUnload];
}
@end
