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

	// Do any additional setup after loading the view.
    //显示目前设定的人数 天数
    NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
    NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
    if (planPerson != NULL)
    {
        self.personsTextField.text = [NSString stringWithFormat:@"%d",[planPerson intValue]];
    }
    else
    {
        self.personsTextField.text = [NSString stringWithFormat:@"%d",1];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanPersonsKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if (planDays != NULL)
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
- (void)viewWillAppear:(BOOL)animated
{

}
- (IBAction)saveChanges:(id)sender
{
    [currentTextField resignFirstResponder];
    int persons = [self.personsTextField.text intValue];
    int days = [self.daysTextField.text intValue];
    if (persons <=0 || days <=0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设置不当" message:@"请输入正确的数字" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
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
    if (planPerson != NULL)
    {
        self.personsTextField.text = [NSString stringWithFormat:@"%d",[planPerson intValue]];
    }
    else
    {
        self.personsTextField.text = [NSString stringWithFormat:@"%d",1];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:LZPlanPersonsKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if (planDays != NULL)
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
    [super viewDidUnload];
}
@end
