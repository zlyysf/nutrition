//
//  LZPersonInfoViewController.m
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZPersonInfoViewController.h"
#import "LZConstants.h"
#import "LZUtility.h"
@interface LZPersonInfoViewController ()

@end

@implementation LZPersonInfoViewController

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
	// Do any additional setup after loading the view.
    self.activityLevelSegmentControl.selectedSegmentIndex = 0;
    self.activityLevelBriefLabel.text = @"Daily activities such as housework or gardening";
}

- (IBAction)activityLevelValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            self.activityLevelBriefLabel.text = @"Daily activities such as housework or gardening";
            break;
        case 1:
            self.activityLevelBriefLabel.text = @"30 minutes of moderate activity such as walking at 4 mph";
            break;
        case 2:
            self.activityLevelBriefLabel.text = @"60 minutes of moderate activity such as walking/jogging at 3-4 mph, or 30 minutes vigorous activity such as jogging at 5.5 mph";
            break;
        case 3:
            self.activityLevelBriefLabel.text = @"45-60 minutes of vigorous activity";
            break;
        default:
            break;
    }
}
- (IBAction)doneButtonTapped:(id)sender
{
    //LZUser
    if ([self.weightTextField.text length] == 0)
    {
        [self alertWithTitle:nil msg:@"需要输入体重"];
        return;
    }
    if ([self.heightTextField.text length] == 0)
    {
        [self alertWithTitle:nil msg:@"需要输入身高"];
        return;
    }
    if ([self.ageTextField.text length] == 0)
    {
        [self alertWithTitle:nil msg:@"需要输入年龄"];
        return;
    }
    float weight = [self.weightTextField.text floatValue];
    float height = [self.heightTextField.text floatValue];
    int age =[self.ageTextField.text integerValue];
    int sex = self.sexSegmentControl.selectedSegmentIndex;
    int activityLevel = self.activityLevelSegmentControl.selectedSegmentIndex;
    [[NSUserDefaults standardUserDefaults]setFloat:weight forKey:LZUserWeightKey];
    [[NSUserDefaults standardUserDefaults]setFloat:height forKey:LZUserHeightKey];
    [[NSUserDefaults standardUserDefaults]setInteger:age forKey:LZUserAgeKey];
    [[NSUserDefaults standardUserDefaults]setInteger:sex forKey:LZUserSexKey];
    [[NSUserDefaults standardUserDefaults]setInteger:activityLevel forKey:LZUserActivityLevelKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    //1[textField becomeFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
    
}// called when 'return' key pressed. return NO to

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
