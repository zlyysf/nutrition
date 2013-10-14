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
#import "LZRecommendFood.h"
#import "LZStandardContentCell.h"
#import "GADMasterViewController.h"
#define kKGConvertLBRatio 2.2046
@interface LZEditProfileViewController ()
@property (assign,nonatomic)BOOL usePound;
@end

@implementation LZEditProfileViewController
@synthesize currentTextField,firstEnterEditView,nutrientStandardArray,maxNutrientCount,admobView;

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
    if (ViewControllerUseBackImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
        [self.mainScrollView setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];

    }
    self.nutrientStandardArray = [[NSMutableArray alloc]init];
    self.title = NSLocalizedString(@"editprofile_viewtitle",@"个人");
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"baocunbutton",@"保存") style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    NSArray *customNutrients = [LZRecommendFood getCustomNutrients:nil];
    maxNutrientCount = [customNutrients count];
    [self.mainScrollView setContentSize:CGSizeMake(320, 391+30*maxNutrientCount+60)];
    self.admobView = [[UIView alloc]initWithFrame:CGRectMake(0, 391+30*maxNutrientCount+10, 320, 50)];
    [self.listViewBGImage setFrame:CGRectMake(10, 391, 300, 30*maxNutrientCount)];
    [self.mainScrollView addSubview:self.admobView];
    UIImage *textImage = [UIImage imageNamed:@"outer_line_bg.png"];
    UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:6 topCapHeight:6];
    [self.listViewBGImage setImage:textBackImage];
    [self.line1View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line2View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line3View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
    [self.line4View setBackgroundColor:[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1.0f]];
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
    [self.maleButton setTitle:NSLocalizedString(@"malebutton", @"男") forState:UIControlStateNormal];
    [self.femaleButton setTitle:NSLocalizedString(@"femalebutton", @"女") forState:UIControlStateNormal];
    self.basicinfoLabel.text = NSLocalizedString(@"editprofile_basicinfolabel", @"基本信息");
    self.ageLabel.text = NSLocalizedString(@"editprofile_agelabel", @"年龄");
    self.ageUnitLabel.text = NSLocalizedString(@"editprofile_ageunitlabel", @"岁");
    self.heightLabel.text = NSLocalizedString(@"editprofile_heightlabel", @"身高");
    self.weightLabel.text = NSLocalizedString(@"editprofile_weightlabel", @"体重");
    self.activityLevelLabel.text = NSLocalizedString(@"editprofile_activitylabel", @"活动强度");
    self.DRILabel.text =NSLocalizedString(@"editprofile_DRIlabel",  @"个人每日营养摄入推荐量");
    self.emptyDRILabel.text = NSLocalizedString(@"editprofile_emptyDRIlabel", @"很抱歉，由于您的基本信息不完全，目前无法显示营养摄入推荐量。");
    if([LZUtility isCurrentLanguageChinese])
    {
        self.usePound = NO;
        self.weightSymbol.text = @"kg";
    }
    else
    {
        self.usePound = YES;
        self.weightSymbol.text = @"lb";
    }
    self.ageTextField.tag= 200;
    self.heightTextField.tag = 201;
    self.weightTextField.tag = 202;
    [self.userTouchReceiverView setFrame:CGRectMake(0, 0, 320, 391+30*maxNutrientCount+60)];
    UITapGestureRecognizer *userTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTouchReceived:)];
    [self.userTouchReceiverView addGestureRecognizer:userTapGesture];
    [self initialPage];
}
-(void)userTouchReceived:(UITapGestureRecognizer*)sender
{
    if(self.currentTextField)
    {
        [self.currentTextField resignFirstResponder];
    }
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
        if (self.usePound)
        {
            self.weightTextField.text = [NSString stringWithFormat:@"%d",(int)([userWeight intValue]*kKGConvertLBRatio)];
        }
        else
        {
            self.weightTextField.text = [NSString stringWithFormat:@"%d",[userWeight intValue]];
        }
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
    CGSize descriptionSize = [currentDes sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(299, 9999) lineBreakMode:UILineBreakModeWordWrap];
    NSString *onlineStr = @"1";
    CGSize onlineSize = [onlineStr sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(299, 9999) lineBreakMode:UILineBreakModeWordWrap];
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
    NSDictionary *dataToSave = [self checkValueValidWithAlertPop:NO];
    if (dataToSave)
    {
        [self displayDRI:dataToSave];
    }
    else
    {
        [self displayEmptyState];
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
    NSDictionary *dataToSave = [self checkValueValidWithAlertPop:NO];
    if (dataToSave)
    {
        [self displayDRI:dataToSave];
    }
    else
    {
        [self displayEmptyState];
    }
}
-(void)displayDRI:(NSDictionary *)info
{
    if(info)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [info objectForKey:LZUserSexKey],ParamKey_sex, [info objectForKey:LZUserAgeKey],ParamKey_age,
                                  [info objectForKey:LZUserWeightKey],ParamKey_weight, [info objectForKey:LZUserHeightKey],ParamKey_height,
                                  [info objectForKey:LZUserActivityLevelKey],ParamKey_activityLevel, nil];
        LZDataAccess *da = [LZDataAccess singleton];
        NSDictionary *DRIsDict = [da getStandardDRIs_withUserInfo:userInfo andOptions:nil];
        
        LZRecommendFood *rf = [[LZRecommendFood alloc]init];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       DRIsDict,Key_DRI,
                                       nil];
        NSMutableDictionary *driDict =  [rf formatDRIForUI:params];
        NSArray *driArray = [driDict objectForKey:@"nutrientsInfoOfDRI"];
        [self.nutrientStandardArray removeAllObjects];
        [self.nutrientStandardArray  addObjectsFromArray:driArray];
        [self.listView reloadData];

    }
    else
    {
        NSNumber *userSex = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserSexKey];
        NSNumber *userAge = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserAgeKey];
        NSNumber *userHeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserHeightKey];
        NSNumber *userWeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserWeightKey];
        NSNumber *userActivityLevel = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserActivityLevelKey];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  userSex,ParamKey_sex, userAge,ParamKey_age,
                                  userWeight,ParamKey_weight, userHeight,ParamKey_height,
                                  userActivityLevel,ParamKey_activityLevel, nil];
        LZDataAccess *da = [LZDataAccess singleton];
        NSDictionary *DRIsDict = [da getStandardDRIs_withUserInfo:userInfo andOptions:nil];
        
        LZRecommendFood *rf = [[LZRecommendFood alloc]init];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       DRIsDict,Key_DRI,
                                       nil];
        NSMutableDictionary *driDict =  [rf formatDRIForUI:params];
        NSArray *driArray = [driDict objectForKey:@"nutrientsInfoOfDRI"];
        [self.nutrientStandardArray removeAllObjects];
        [self.nutrientStandardArray  addObjectsFromArray:driArray];
        [self.listView reloadData];
    }
    self.emptyDRILabel.hidden = YES;
    self.listView.hidden = NO;
    self.listViewBGImage.hidden = NO;

    
//    NSLog(@"%@",self.nutrientStandardArray);

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    LZKeyboardToolBar *keyboardToolbar = [[LZKeyboardToolBar alloc]initWithFrame:kKeyBoardToolBarRect doneButtonTitle:NSLocalizedString(@"wanchengbutton",@"完成") delegate:self];
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
    else
    {
        return YES;
    }
    //    }
    //    else {
    //        return NO;
    //    }
    
}
- (void)textFieldValueChanged:(NSNotification *)notification {
    NSDictionary *dataToSave = [self checkValueValidWithAlertPop:NO];
    if (dataToSave)
    {
        [self displayDRI:dataToSave];
    }
    else
    {
        [self displayEmptyState];
    }

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
    if(self.currentTextField)
    {
        [self.currentTextField resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [MobClick beginLogPageView:UmengPathGeRenXinXi];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    if (!firstEnterEditView)
    {
        [self displayDRI:nil];
    }
    else
    {
        [self displayEmptyState];
    }
}
-(void)displayEmptyState
{
    self.listView.hidden = YES;
    self.listViewBGImage.hidden = YES;
    self.emptyDRILabel.hidden = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [MobClick endLogPageView:UmengPathGeRenXinXi];
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
    NSDictionary *dataToSave = [self checkValueValidWithAlertPop:YES];
    if(dataToSave)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserAgeKey] forKey:LZUserAgeKey];
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserSexKey] forKey:LZUserSexKey];
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserHeightKey] forKey:LZUserHeightKey];
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserWeightKey] forKey:LZUserWeightKey];
        [[NSUserDefaults standardUserDefaults]setObject:[dataToSave objectForKey:LZUserActivityLevelKey] forKey:LZUserActivityLevelKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
       [[NSNotificationCenter defaultCenter]postNotificationName:Notification_SettingsChangedKey object:nil userInfo:nil];
        if (!firstEnterEditView)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}
-(NSDictionary *)checkValueValidWithAlertPop:(BOOL)shouldPopAlert
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
        if (shouldPopAlert)
        {
            [self alertWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") msg:NSLocalizedString(@"editprofile_alert0_message",@"性别选择错误，请重新选择")];
        }
        return nil;
    }
    if (self.currentActivityLevelSelection >= 0 && self.currentActivityLevelSelection <= 3)
    {
        [dataToSave setObject:[NSNumber numberWithInt:self.currentActivityLevelSelection] forKey:LZUserActivityLevelKey];
    }
    else
    {
        if (shouldPopAlert)
        {
            [self alertWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") msg:NSLocalizedString(@"editprofile_alert1_message",@"活动强度选择错误，请重新选择")];
        }
        return nil;
    }
    int userAge = [self.ageTextField.text intValue];
    if (userAge >= 1)//年龄 岁
    {
        [dataToSave setObject:[NSNumber numberWithInt:userAge] forKey:LZUserAgeKey];
    }
    else
    {
        if (shouldPopAlert)
        {
            [self alertWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") msg:NSLocalizedString(@"editprofile_alert2_message",@"年龄填写错误，请重新填写")];
        }
        return nil;
    }
    int userHeight = [self.heightTextField.text intValue];
    if (userHeight > 0)//身高 cm
    {
        [dataToSave setObject:[NSNumber numberWithInt:userHeight] forKey:LZUserHeightKey];
    }
    else
    {
        if (shouldPopAlert)
        {
            [self alertWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") msg:NSLocalizedString(@"editprofile_alert3_message",@"身高填写错误，请重新填写")];
        }
        return nil;
    }

    int userWeight = [self.weightTextField.text intValue];
    if (userWeight > 0)//体重 kg
    {
        if (self.usePound)
        {
            int convertedWeight = (int)(userWeight/kKGConvertLBRatio);
            [dataToSave setObject:[NSNumber numberWithInt:convertedWeight] forKey:LZUserWeightKey];
        }
        else
        {
            [dataToSave setObject:[NSNumber numberWithInt:userWeight] forKey:LZUserWeightKey];
        }
    }
    else
    {
        if (shouldPopAlert)
        {
            [self alertWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") msg:NSLocalizedString(@"editprofile_alert4_message",@"体重填写错误，请重新填写")];
        }
        return nil;
    }
    return dataToSave;
}
- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"quedingbutton",@"确定")
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
    [self setListView:nil];
    [self setEmptyDRILabel:nil];
    [self setListViewBGImage:nil];
    [self setBasicinfoLabel:nil];
    [self setAgeLabel:nil];
    [self setHeightLabel:nil];
    [self setWeightLabel:nil];
    [self setAgeUnitLabel:nil];
    [self setActivityLevelLabel:nil];
    [self setDRILabel:nil];
    [self setWeightSymbol:nil];
    [self setUserTouchReceiverView:nil];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (nutrientStandardArray != nil && [nutrientStandardArray count]!=0)
    {
        return [nutrientStandardArray count];
    }
    else
        return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LZStandardContentCell *cell = (LZStandardContentCell *)[tableView dequeueReusableCellWithIdentifier:@"LZStandardContentCell"];
    NSDictionary *nutrientStandard = [nutrientStandardArray objectAtIndex:indexPath.row];
    NSString *nutrientName = [nutrientStandard objectForKey:@"NutrientCnCaption"];
    NSNumber *foodNutrientContent = [nutrientStandard objectForKey:@"Amount"];
    NSString *unit = [nutrientStandard objectForKey:@"NutrientEnUnit"];
    if (indexPath.row == [nutrientStandardArray count]-1)
    {
        cell.sepratorLine.hidden = YES;
    }
    else
    {
        cell.sepratorLine.hidden = NO;
    }
    cell.nutritionNameLabel.text = nutrientName;
    cell.nutritionSupplyLabel.text = [NSString stringWithFormat:@"%.2f%@",[foodNutrientContent floatValue],unit];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    
//    return 37;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 37)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    
//    UIImageView *sectionBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
//    [sectionView addSubview:sectionBarView];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"section_bar@2x" ofType:@"png"];
//    UIImage * sectionBarImage = [UIImage imageWithContentsOfFile:path];
//    [sectionBarView setImage:sectionBarImage];
//    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 27)];
//    [sectionTitleLabel setTextColor:[UIColor whiteColor]];
//    [sectionTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
//    [sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
//    [sectionView addSubview:sectionTitleLabel];
//    
//    sectionTitleLabel.text = [NSString stringWithFormat:@"个人每日营养摄入推荐量"];
//    return sectionView;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}// Default is 1 if not implemented

@end
