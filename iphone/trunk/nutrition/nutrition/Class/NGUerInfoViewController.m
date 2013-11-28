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
@interface NGUerInfoViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,LZKeyboardToolBarDelegate>
@property (nonatomic,strong)UITextField *currentTextField;

@end

@implementation NGUerInfoViewController
@synthesize birthdayPicker,heightPicker,currentTextField;
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
    self.birthdayLabel.text = @"生日";
    self.heightLabel.text = @"身高";
    self.sexLabel.text = @"性别";
    self.weightLabel.text = @"体重";
    self.activityLabel.text = @"活动强度";
    self.birthdayPicker = [[UIPickerView alloc]init];
    self.birthdayPicker.delegate = self;
    self.birthdayPicker.dataSource = self;
    self.heightPicker = [[UIPickerView alloc]init];
    self.heightPicker.delegate = self;
    self.heightPicker.dataSource = self;
    NSArray *levelArray = [[LZUtility getActivityLevelInfo]objectForKey:@"levelArray"];
    [self.sexSegmentControll setTitle:NSLocalizedString(@"malebutton", @"男") forSegmentAtIndex:0];
    [self.sexSegmentControll setTitle:NSLocalizedString(@"femalebutton", @"女") forSegmentAtIndex:1];
    [self.activitySegmentControll setTitle:[levelArray objectAtIndex:0] forSegmentAtIndex:0];
    [self.activitySegmentControll setTitle:[levelArray objectAtIndex:1] forSegmentAtIndex:1];
    [self.activitySegmentControll setTitle:[levelArray objectAtIndex:2] forSegmentAtIndex:2];
    [self.activitySegmentControll setTitle:[levelArray objectAtIndex:3] forSegmentAtIndex:3];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"baocunbutton",@"保存") style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    NSNumber *userSex = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserSexKey];
    [self.sexSegmentControll setSelectedSegmentIndex:[userSex intValue]];
    NSNumber *userActivityLevel = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserActivityLevelKey];
    [self.activitySegmentControll setSelectedSegmentIndex:[userActivityLevel intValue]];
    NSNumber *userWeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserWeightKey];
    if (userWeight == nil)
    {
        self.weightTextField.text = @"";
    }

	// Do any additional setup after loading the view.
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [self.listView setContentSize:self.view.bounds.size];
//}
-(void)viewWillAppear:(BOOL)animated
{
    [self.listView setContentSize:self.view.bounds.size];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)keyboardWillShow:(NSNotification *)notification {
	
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *boundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [boundsValue CGRectValue];
    
    CGFloat keyboardTop = self.view.frame.size.height - keyboardRect.size.height+49;
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.birthdayPicker)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.birthdayPicker)
    {
        if (component == 0)
        {
            return 80;
        }
        return 12;
    }
    else
    {
        return 100;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.birthdayPicker)
    {
        if (component == 0)
        {
            return [NSString stringWithFormat:@"%d",1940+row];
        }
        return [NSString stringWithFormat:@"%d",row+1];
    }
    else
    {
        return [NSString stringWithFormat:@"%d",100+row];
    }

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    LZKeyboardToolBar *keyboardToolbar = [[LZKeyboardToolBar alloc]initWithFrame:kKeyBoardToolBarRect doneButtonTitle:NSLocalizedString(@"wanchengbutton",@"完成") delegate:self];
    if (textField == self.birthdayTextField)
    {
        
        textField.inputView = self.birthdayPicker;
    }
    else if (textField == self.heightTextField)
    {
        textField.inputView = self.heightPicker;
        
    }
    textField.inputAccessoryView = keyboardToolbar;
    self.currentTextField = textField;
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

#pragma mark- LZKeyboardToolBarDelegate
-(void)toolbarKeyboardDone
{
    if(self.currentTextField)
    {
        [self.currentTextField resignFirstResponder];
    }
}
- (IBAction)sexValueChanged:(UISegmentedControl *)sender {
}
@end
