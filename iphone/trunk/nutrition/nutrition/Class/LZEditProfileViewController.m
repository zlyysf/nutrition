//
//  LZEditProfileViewController.m
//  nutrition
//
//  Created by liu miao on 7/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZEditProfileViewController.h"
#import "LZConstants.h"
#import "MobClick.h"
#import "LZUtility.h"
@interface LZEditProfileViewController ()

@end

@implementation LZEditProfileViewController
@synthesize currentTextField,firstEnterEditView;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.mainScrollView setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    if (!firstEnterEditView)
    {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
        self.title = @"编辑个人资料";
    }
    else
    {
        self.title = @"填写个人资料";
    }
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    [self.mainScrollView setContentSize:CGSizeMake(320, 400)];
    UIImage *textImage = [UIImage imageNamed:@"setting_cell_back.png"];
    UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    [self.line1View setBackgroundColor:[UIColor colorWithRed:198/255.f green:185/255.f blue:173/255.f alpha:1.0f]];
    [self.line2View setBackgroundColor:[UIColor colorWithRed:198/255.f green:185/255.f blue:173/255.f alpha:1.0f]];
    [self.line3View setBackgroundColor:[UIColor colorWithRed:198/255.f green:185/255.f blue:173/255.f alpha:1.0f]];
    [self.line4View setBackgroundColor:[UIColor colorWithRed:198/255.f green:185/255.f blue:173/255.f alpha:1.0f]];
    [self.ageBackImageView setImage:textBackImage];
    [self.heightBackImageView setImage:textBackImage];
    [self.weightBackImageView setImage:textBackImage];
    self.maleButton.tag = 10;
    self.femaleButton.tag = 11;
    self.level0Button.tag= 100;
    self.level1Button.tag = 101;
    self.level2Button.tag = 102;
    self.level3Button.tag = 103;
    NSArray *levelArray = [[LZUtility getActivityLevelInfo]objectForKey:@"levelArray"];
    [self.level0Button setTitle:[levelArray objectAtIndex:0] forState:UIControlStateNormal];
    [self.level1Button setTitle:[levelArray objectAtIndex:1] forState:UIControlStateNormal];
    [self.level2Button setTitle:[levelArray objectAtIndex:2] forState:UIControlStateNormal];
    [self.level3Button setTitle:[levelArray objectAtIndex:3] forState:UIControlStateNormal];
    [self.level0Button addTarget:self action:@selector(levelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.level1Button addTarget:self action:@selector(levelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.level2Button addTarget:self action:@selector(levelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.level3Button addTarget:self action:@selector(levelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.femaleButton addTarget:self action:@selector(sexButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.maleButton addTarget:self action:@selector(sexButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.ageTextField.tag= 200;
    self.heightTextField.tag = 201;
    self.weightTextField.tag = 202;
    [self initialPage];
}
-(void)initialPage
{
    //填入各项数据
    NSNumber *userSex = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserSexKey];
    NSNumber *userAge = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserAgeKey];
    NSNumber *userHeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserHeightKey];
    NSNumber *userWeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserWeightKey];
    NSNumber *userActivityLevel = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserActivityLevelKey];
    if ([userSex intValue] == 0)
    {
        [self sexButtonTapped:self.maleButton];
    }
    else
    {
        [self sexButtonTapped:self.femaleButton];
    }
    
    if (userAge == nil)
    {
        self.ageTextField.text = @"";
    }
    else
    {
        self.ageTextField.text = [NSString stringWithFormat:@"%d",[userAge intValue]];
    }
    if (userHeight == nil)
    {
        self.heightTextField.text = @"";
    }
    else
    {
        self.heightTextField.text = [NSString stringWithFormat:@"%d",[userHeight intValue]];
    }

    if (userWeight == nil)
    {
        self.weightTextField.text = @"";
    }
    else
    {
        self.weightTextField.text = [NSString stringWithFormat:@"%d",[userWeight intValue]];
    }
    
    int activityLevel = [userActivityLevel intValue];
    switch (activityLevel) {
        case 0:
            [self levelButtonTapped:self.level0Button];
            break;
        case 1:
            [self levelButtonTapped:self.level1Button];
            break;
        case 2:
            [self levelButtonTapped:self.level2Button];
            break;
        case 3:
            [self levelButtonTapped:self.level3Button];
            break;
        default:
            break;
    }
    

}
-(void)levelButtonTapped:(UIButton *)tappedButton
{
    UIImage *left_normal = [[UIImage imageNamed:@"edit_left_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage *left_clicked = [[UIImage imageNamed:@"edit_left_clicked"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage *right_normal = [[UIImage imageNamed:@"edit_right_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage *right_clicked = [[UIImage imageNamed:@"edit_right_clicked"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage *mid_normal = [[UIImage imageNamed:@"edit_mid_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage *mid_clicked = [[UIImage imageNamed:@"edit_mid_clicked"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    int tag = tappedButton.tag;
    NSArray *levelArray = [[LZUtility getActivityLevelInfo]objectForKey:@"levelArray"];
    NSDictionary *levelDes = [[LZUtility getActivityLevelInfo]objectForKey:@"levelDescription"];
    NSString *currentLevel = [levelArray objectAtIndex:tag-100];
    NSString *currentDes = [levelDes objectForKey:currentLevel];
    CGSize descriptionSize = [currentDes sizeWithFont:[UIFont systemFontOfSize:12]constrainedToSize:CGSizeMake(299, 9999) lineBreakMode:UILineBreakModeWordWrap];
    NSString *onlineStr = @"1";
    CGSize onlineSize = [onlineStr sizeWithFont:[UIFont systemFontOfSize:12]constrainedToSize:CGSizeMake(299, 9999) lineBreakMode:UILineBreakModeWordWrap];
    float onelineHeight = onlineSize.height;
    float desHeight = descriptionSize.height;
    if (desHeight > onelineHeight)
    {
        self.levelDescriptionLabel.textAlignment = UITextAlignmentLeft;
    }
    else
    {
        self.levelDescriptionLabel.textAlignment = UITextAlignmentCenter;
    }
    CGRect labelFrame = self.levelDescriptionLabel.frame;
    labelFrame.size.height = descriptionSize.height;
    self.levelDescriptionLabel.frame = labelFrame;
    self.levelDescriptionLabel.text = currentDes;
    
    switch (tag)
    {
        case 100:
            self.currentActivityLevelSelection = 0;
            [self.level0Button setBackgroundImage:left_clicked forState:UIControlStateNormal];
            [self.level0Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.level0Button setBackgroundImage:left_clicked forState:UIControlStateHighlighted];
            [self.level0Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level1Button setBackgroundImage:mid_normal forState:UIControlStateNormal];
            [self.level1Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level1Button setBackgroundImage:mid_clicked forState:UIControlStateHighlighted];
            [self.level2Button setBackgroundImage:mid_normal forState:UIControlStateNormal];
            [self.level2Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level2Button setBackgroundImage:mid_clicked forState:UIControlStateHighlighted];
            [self.level3Button setBackgroundImage:right_normal forState:UIControlStateNormal];
            [self.level3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level3Button setBackgroundImage:right_clicked forState:UIControlStateHighlighted];
            break;
        case 101:
            self.currentActivityLevelSelection = 1;
            [self.level0Button setBackgroundImage:left_normal forState:UIControlStateNormal];
            [self.level0Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level0Button setBackgroundImage:left_clicked forState:UIControlStateHighlighted];
            [self.level0Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level1Button setBackgroundImage:mid_clicked forState:UIControlStateNormal];
            [self.level1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.level1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level1Button setBackgroundImage:mid_clicked forState:UIControlStateHighlighted];
            [self.level2Button setBackgroundImage:mid_normal forState:UIControlStateNormal];
            [self.level2Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level2Button setBackgroundImage:mid_clicked forState:UIControlStateHighlighted];
            [self.level3Button setBackgroundImage:right_normal forState:UIControlStateNormal];
            [self.level3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level3Button setBackgroundImage:right_clicked forState:UIControlStateHighlighted];

            break;
        case 102:
            self.currentActivityLevelSelection = 2;
            [self.level0Button setBackgroundImage:left_normal forState:UIControlStateNormal];
            [self.level0Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level0Button setBackgroundImage:left_clicked forState:UIControlStateHighlighted];
            [self.level0Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level1Button setBackgroundImage:mid_normal forState:UIControlStateNormal];
            [self.level1Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level1Button setBackgroundImage:mid_clicked forState:UIControlStateHighlighted];
            [self.level2Button setBackgroundImage:mid_clicked forState:UIControlStateNormal];
            [self.level2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.level2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level2Button setBackgroundImage:mid_clicked forState:UIControlStateHighlighted];
            [self.level3Button setBackgroundImage:right_normal forState:UIControlStateNormal];
            [self.level3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level3Button setBackgroundImage:right_clicked forState:UIControlStateHighlighted];

            break;
        case 103:
            self.currentActivityLevelSelection = 3;
            [self.level0Button setBackgroundImage:left_normal forState:UIControlStateNormal];
            [self.level0Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level0Button setBackgroundImage:left_clicked forState:UIControlStateHighlighted];
            [self.level0Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level1Button setBackgroundImage:mid_normal forState:UIControlStateNormal];
            [self.level1Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level1Button setBackgroundImage:mid_clicked forState:UIControlStateHighlighted];
            [self.level2Button setBackgroundImage:mid_normal forState:UIControlStateNormal];
            [self.level2Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.level2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level2Button setBackgroundImage:mid_clicked forState:UIControlStateHighlighted];
            [self.level3Button setBackgroundImage:right_clicked forState:UIControlStateNormal];
            [self.level3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.level3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.level3Button setBackgroundImage:right_clicked forState:UIControlStateHighlighted];

            break;
        default:
            break;
    }
}
- (void)sexButtonTapped:(UIButton *)tappedButton
{
    UIImage *left_normal = [[UIImage imageNamed:@"edit_left_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage *left_clicked = [[UIImage imageNamed:@"edit_left_clicked"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage *right_normal = [[UIImage imageNamed:@"edit_right_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage *right_clicked = [[UIImage imageNamed:@"edit_right_clicked"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    int tag = tappedButton.tag;
    if (tag == 10)
    {
        self.currentSexSelection = 0;
        [self.maleButton setBackgroundImage:left_clicked forState:UIControlStateNormal];
        [self.maleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.maleButton setBackgroundImage:left_clicked forState:UIControlStateHighlighted];
        [self.maleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.femaleButton setBackgroundImage:right_normal forState:UIControlStateNormal];
        [self.femaleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.femaleButton setBackgroundImage:right_clicked forState:UIControlStateHighlighted];
    }
    else if (tag == 11)
    {
        self.currentSexSelection = 1;
        [self.femaleButton setBackgroundImage:right_clicked forState:UIControlStateNormal];
        [self.femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.femaleButton setBackgroundImage:right_clicked forState:UIControlStateHighlighted];
        [self.femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.maleButton setBackgroundImage:left_normal forState:UIControlStateNormal];
        [self.maleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.maleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.maleButton setBackgroundImage:left_clicked forState:UIControlStateHighlighted];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    LZKeyboardToolBar *keyboardToolbar = [[LZKeyboardToolBar alloc]initWithFrame:kKeyBoardToolBarRect doneButtonTitle:@"完成" delegate:self];
    textField.inputAccessoryView = keyboardToolbar;
    self.currentTextField = textField;
    int tag = textField.tag;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (tag == 200)
        {
            [self.mainScrollView setContentOffset:CGPointMake(0, 55) animated:YES];
        }
        else if (tag == 201)
        {
            [self.mainScrollView setContentOffset:CGPointMake(0, 105) animated:YES];
        }
        else if (tag == 202)
        {
            [self.mainScrollView setContentOffset:CGPointMake(0, 155) animated:YES];
        }

    });

    //[textField becomeFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    NSCharacterSet *cs;
    //    cs = [[NSCharacterSet characterSetWithCharactersInString:] invertedSet];
    //    NSString *filtered =
    //    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    //    BOOL basic = [string isEqualToString:filtered];
    //    if (basic)
    //    {
    if ([string length]+[textField.text length]>3)
    {
        return NO;
    }
    return YES;
    //    }
    //    else {
    //        return NO;
    //    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //记录用量
    
    //    if(delegate && [delegate respondsToSelector:@selector(textFieldDidReturnForIndex:)])
    //    {
    //        [delegate textFieldDidReturnForIndex:self.cellIndexPath];
    //    }
    [textField resignFirstResponder];
    return YES;
    
}// called when 'return' key pressed. return NO to
-(void)toolbarKeyboardDone
{
    [self.currentTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [MobClick beginLogPageView:@"编辑个人资料页面"];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [MobClick endLogPageView:@"编辑个人资料页面"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cancelButtonTapped
{
    if (self.currentTextField != nil)
    {
        [self.currentTextField resignFirstResponder];
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (void)saveButtonTapped
{
    if (self.currentTextField != nil)
    {
        [self.currentTextField resignFirstResponder];
    }
    NSDictionary *dataToSave = [self checkValueValid];
    if(dataToSave)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserAgeKey] forKey:LZUserAgeKey];
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserSexKey] forKey:LZUserSexKey];
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserHeightKey] forKey:LZUserHeightKey];
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserWeightKey] forKey:LZUserWeightKey];
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserActivityLevelKey] forKey:LZUserActivityLevelKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
       [[NSNotificationCenter defaultCenter]postNotificationName:Notification_SettingsChangedKey object:nil userInfo:nil];
        [self dismissModalViewControllerAnimated:YES];
    }
}
-(NSDictionary *)checkValueValid
{
    //NSNumber *userSex = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserSexKey];
    //NSNumber *userAge = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserAgeKey];
    //NSNumber *userHeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserHeightKey];
    //NSNumber *userWeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserWeightKey];
    NSMutableDictionary *dataToSave = [[NSMutableDictionary alloc]init];
    if (self.currentSexSelection ==0 || self.currentSexSelection == 1)
    {
        [dataToSave setObject:[NSNumber numberWithInt:self.currentSexSelection] forKey:LZUserSexKey];
    }
    else
    {
        [self alertWithTitle:@"" msg:@"性别选择错误，请重新选择"];
        return nil;
    }
    if (self.currentActivityLevelSelection >= 0 && self.currentActivityLevelSelection <= 3)
    {
        [dataToSave setObject:[NSNumber numberWithInt:self.currentActivityLevelSelection] forKey:LZUserActivityLevelKey];
    }
    else
    {
        [self alertWithTitle:@"" msg:@"活动强度选择错误，请重新选择"];
        return nil;
    }
    int userAge = [self.ageTextField.text intValue];
    if (userAge >= 1)//年龄 岁
    {
        [dataToSave setObject:[NSNumber numberWithInt:userAge] forKey:LZUserAgeKey];
    }
    else
    {
        [self alertWithTitle:@"" msg:@"年龄数据填写错误，请重新填写"];
        return nil;
    }
    int userHeight = [self.heightTextField.text intValue];
    if (userHeight > 0)//身高 cm
    {
        [dataToSave setObject:[NSNumber numberWithInt:userHeight] forKey:LZUserHeightKey];
    }
    else
    {
        [self alertWithTitle:@"" msg:@"身高数据填写错误，请重新填写"];
        return nil;
    }

    int userWeight = [self.weightTextField.text intValue];
    if (userWeight > 0)//体重 kg
    {
        [dataToSave setObject:[NSNumber numberWithInt:userWeight] forKey:LZUserWeightKey];
    }
    else
    {
        [self alertWithTitle:@"" msg:@"体重数据填写错误，请重新填写"];
        return nil;
    }

    return dataToSave;
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
- (void)viewDidUnload {
    [self setMaleButton:nil];
    [self setFemaleButton:nil];
    [self setAgeBackImageView:nil];
    [self setHeightBackImageView:nil];
    [self setWeightBackImageView:nil];
    [self setAgeTextField:nil];
    [self setHeightTextField:nil];
    [self setWeightTextField:nil];
    [self setLevel0Button:nil];
    [self setLevel1Button:nil];
    [self setLevel2Button:nil];
    [self setLevel3Button:nil];
    [self setLevelDescriptionLabel:nil];
    [self setMainScrollView:nil];
    [self setLine1View:nil];
    [self setLine2View:nil];
    [self setLine3View:nil];
    [self setLine4View:nil];
    [super viewDidUnload];
}
- (void)keyboardWillShow:(NSNotification *)notification {
	
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *boundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [boundsValue CGRectValue];
    
    CGFloat keyboardTop = self.view.frame.size.height - keyboardRect.size.height;
    CGRect tableviewFrame = self.mainScrollView.frame;
	tableviewFrame.size.height = keyboardTop;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.mainScrollView.frame = tableviewFrame;
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
	CGRect tableviewFrame = self.mainScrollView.frame;
	tableviewFrame.size.height = self.view.frame.size.height;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.mainScrollView.frame = tableviewFrame;
    [UIView commitAnimations];
    
}

@end
