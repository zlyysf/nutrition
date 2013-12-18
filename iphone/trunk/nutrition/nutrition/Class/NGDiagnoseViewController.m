//
//  NGDiagnoseViewController.m
//  nutrition
//
//  Created by liu miao on 11/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGDiagnoseViewController.h"
#import "NGDiagnoseCell.h"
#import "LZDataAccess.h"
#import "LZConstants.h"
#import "LZUtility.h"
#import "NGMeasurementCell.h"
#import "NGNoteCell.h"
#import "LZKeyboardToolBar.h"
#import "NGHealthReportViewController.h"
#import "LZRecommendFood.h"
@interface NGDiagnoseViewController ()<NGDiagnosesViewDelegate,LZKeyboardToolBarDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    BOOL isChinese;
}
@property (strong,nonatomic) UITextField *currentTextField;
@property (strong,nonatomic) UITextView *currentTextView;
@property (strong,nonatomic) NSMutableDictionary *userInputValueDict;
@property (strong,nonatomic) NSArray *symptomTypeRows;
@property (assign,nonatomic)BOOL needRefresh;
@end

@implementation NGDiagnoseViewController
@synthesize symptomTypeIdArray,symptomRowsDict,symptomStateDict,currentTextField,userInputValueDict,userSelectedSymptom,needRefresh,symptomTypeRows;
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
    self.title = NSLocalizedString(@"jiankangjilu_title", @"健康记录");
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 4, 280, 21)];
    [label setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setText:NSLocalizedString(@"jiankangjilu_question", @"今天哪里不舒服吗？点击记录一下吧。")];
    [label setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label];
    self.listView.tableHeaderView = headerView;
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    UIBarButtonItem *submitItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"jiankangjilu_tijiao", @"提交") style:UIBarButtonItemStyleBordered target:self action:@selector(getHealthReport)];
    [submitItem setEnabled:NO];
    self.navigationItem.rightBarButtonItem = submitItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged:) name:Notification_SettingsChangedKey object:nil];
    isChinese =[LZUtility isCurrentLanguageChinese];
    userSelectedSymptom = [[NSMutableArray alloc]init];
    needRefresh = NO;
    [self refresh];
    
    	// Do any additional setup after loading the view.
}
-(void)getHealthReport
{
    if(self.currentTextField)
    {
        [self.currentTextField resignFirstResponder];
    }
    if (self.currentTextView)
    {
        [self.currentTextView resignFirstResponder];
    }

    //根据状态dict 得到用户选的症状
//    NSMutableArray *userSelectedSymptom = [[NSMutableArray alloc]init];//需保存数据
//    for (NSString *symptomId in [symptomStateDict allKeys])
//    {
//        NSArray *stateArray = [symptomStateDict objectForKey:symptomId];
//        for (int i=0 ;i< [stateArray count];i++)
//        {
//            NSNumber *state = [stateArray objectAtIndex:i];
//            if ([state boolValue])
//            {
//                NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:symptomId];
//                NSDictionary *symptomDict = [symptomIdRelatedArray objectAtIndex:i];
//                NSString *symptomName = [symptomDict objectForKey:@"SymptomId"];
//                [userSelectedSymptom addObject:symptomName];
//            }
//        }
//    }
    if ([userSelectedSymptom count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请至少选择一个症状" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //笔记
    
    NSString *note = [self.userInputValueDict objectForKey:@"note"];//需保存数据
    
    //根据症状获得症状健康分值
    LZDataAccess *da = [LZDataAccess singleton];
    double symptomScore = [da getSymptomHealthMarkSum_BySymptomIds:userSelectedSymptom];
    double healthScore = 100 - symptomScore;//需保存数据
    if (healthScore<Config_nearZero)
    {
        healthScore = 0;
    }

    
    //根据症状和测量数据得到用户的潜在疾病和BMI值
        //1.计算BMI
    NSString *weight = [self.userInputValueDict objectForKey:@"weight"];
    NSString *heat = [self.userInputValueDict objectForKey:@"heat"];
    NSString *heartbeat = [self.userInputValueDict objectForKey:@"heartbeat"];
    NSString *highpress = [self.userInputValueDict objectForKey:@"highpressure"];
    NSString *lowpress = [self.userInputValueDict objectForKey:@"lowpressure"];
    NSNumber *userWeight = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserWeightKey];
    NSNumber *paramHeight = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserHeightKey];
    double userBMI;//需保存数据
    NSMutableDictionary *measureData = [[NSMutableDictionary alloc]init];
    if ([weight length] == 0 || [weight doubleValue]<=0)
    {
        userBMI = [LZUtility getBMI_withWeight:[userWeight doubleValue] andHeight:([paramHeight doubleValue]/100.f)];
    }
    else
    {
        NSNumber *newWeight;
        if (isChinese)
        {
            newWeight = [NSNumber numberWithDouble:[weight doubleValue]];
        }
        else
        {
            double convertedWeight = (double)([weight doubleValue]/kKGConvertLBRatio);
            newWeight = [NSNumber numberWithDouble:convertedWeight];
        }
        [[NSUserDefaults standardUserDefaults]setObject:newWeight forKey:LZUserWeightKey];
        [measureData setObject:newWeight forKey:Key_Weight];
        [[NSUserDefaults standardUserDefaults]synchronize];
        userBMI = [LZUtility getBMI_withWeight:[newWeight doubleValue] andHeight:([paramHeight doubleValue]/100.f)];
    }
        //2.计算潜在疾病
    
    if ([heat length] != 0 && [heat doubleValue]>0)
    {
        [measureData setObject:[NSNumber numberWithDouble:[heat doubleValue]] forKey:Key_BodyTemperature];
    }
    if ([heartbeat length] != 0 && [heartbeat intValue]>0)
    {
        [measureData setObject:[NSNumber numberWithInt:[heartbeat intValue]] forKey:Key_HeartRate];
    }
    if ([lowpress length] != 0 && [lowpress intValue]>0)
    {
        [measureData setObject:[NSNumber numberWithInt:[lowpress intValue]] forKey:Key_BloodPressureLow];
    }
    if ([highpress length] != 0 && [highpress intValue]>0)
    {
        [measureData setObject:[NSNumber numberWithInt:[highpress intValue]] forKey:Key_BloodPressureHigh];
    }
    NSArray *illnessAry = [LZUtility inferIllnesses_withSymptoms:userSelectedSymptom andMeasureData:measureData];//需保存数据
    
    //根据潜在疾病得到注意事项
    NSMutableDictionary *illnessAttentionDict = [[NSMutableDictionary alloc]init];//需保存数据
    for (NSString *illnessId in illnessAry)
    {
        NSArray *illnessIds = [NSArray arrayWithObject:illnessId];
        NSArray *attentionItem = [da getIllnessSuggestionsDistinct_ByIllnessIds:illnessIds];
        if (attentionItem)
        {
            [illnessAttentionDict setObject:attentionItem forKey:illnessId];
        }
    }
    
    //根据症状获得用户缺少的营养元素
    NSArray *lackNutritionArray =  [da getSymptomNutrientDistinctIds_BySymptomIds:userSelectedSymptom];//需保存数据
    
    //根据缺少元素得到推荐的食物
    NSNumber *paramSex = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserSexKey];
    NSNumber *paramAge = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserAgeKey];
    NSNumber *paramWeight = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserWeightKey];
    NSNumber *paramActivity = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserActivityLevelKey];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              paramSex,ParamKey_sex, paramAge,ParamKey_age,
                              paramWeight,ParamKey_weight, paramHeight,ParamKey_height,
                              paramActivity,ParamKey_activityLevel, nil];
    NSArray *nutrientIds = [LZRecommendFood getCustomNutrients:nil];
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary * recommendedFoods = [rf getSingleNutrientRichFoodWithAmount_forNutrients:nutrientIds withUserInfo:userInfo andOptions:nil];//需保存数据
    
    //把保存数据封装，判断今天是否保存过了，如果还没有，则自动保存，如果保存过了，传递给reportcontroller，由用户选择是否再次保存
        //1. 封装数据
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] init]];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dayStr = [formatter stringFromDate:today];
    int dayLocal = [dayStr intValue];
    NSMutableDictionary * InputNameValuePairsData = [NSMutableDictionary dictionary];
    [InputNameValuePairsData setObject:userSelectedSymptom forKey:Key_Symptoms];
    if ([measureData objectForKey:Key_BodyTemperature]) {
        [InputNameValuePairsData setObject:[measureData objectForKey:Key_BodyTemperature] forKey:Key_Temperature];
    }
    if ([measureData objectForKey:Key_Weight]) {
        [InputNameValuePairsData setObject:[measureData objectForKey:Key_Weight] forKey:Key_Weight];
    }
    if ([measureData objectForKey:Key_HeartRate]) {
        [InputNameValuePairsData setObject:[measureData objectForKey:Key_HeartRate] forKey:Key_HeartRate];
    }
    if ([measureData objectForKey:Key_BloodPressureLow]) {
        [InputNameValuePairsData setObject:[measureData objectForKey:Key_BloodPressureLow] forKey:Key_BloodPressureLow];
    }
    if ([measureData objectForKey:Key_BloodPressureHigh]) {
        [InputNameValuePairsData setObject:[measureData objectForKey:Key_BloodPressureHigh] forKey:Key_BloodPressureHigh];
    }
    
    NSMutableDictionary * CalculateNameValuePairsData = [NSMutableDictionary dictionary];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:userBMI] forKey:Key_BMI];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:healthScore] forKey:Key_HealthMark];
    NSMutableDictionary *LackNutrientsAndFoods = [NSMutableDictionary dictionary];
    for (NSString *nutritionId in lackNutritionArray)
    {
        NSArray *recFood = [recommendedFoods objectForKey:nutritionId];
        NSMutableDictionary *relatedFood = [[NSMutableDictionary alloc]init];
        for (NSDictionary * aFood in recFood)
        {
            NSNumber *amount = [aFood objectForKey:@"FoodAmount"];
            NSString *foodId = [aFood objectForKey:@"NDB_No"];
            [relatedFood setObject:amount forKey:foodId];
        }
        [LackNutrientsAndFoods setObject:relatedFood forKey:nutritionId];
    }
    [CalculateNameValuePairsData setObject:LackNutrientsAndFoods forKey:Key_LackNutrientsAndFoods];
    NSMutableDictionary *illnessAttention = [[NSMutableDictionary alloc]init];
    
    for (NSString *illnessId in illnessAry)
    {
        NSArray *attentionArray = [illnessAttentionDict objectForKey:illnessId];
        NSMutableArray *attentionIdArray = [[NSMutableArray alloc]init];
        if (attentionArray != nil && [attentionArray count]!= 0)
        {
            for (NSDictionary *anAttention in attentionArray)
            {
                NSString *attentionId = [anAttention objectForKey:@"SuggestionId"];
                [attentionIdArray addObject:attentionId];
            }
            [illnessAttention setObject:attentionIdArray forKey:illnessId];
        }
    }

    [CalculateNameValuePairsData setObject:illnessAttention forKey:Key_InferIllnessesAndSuggestions];


        //2.判断
    NSDictionary *recordData = [da getUserRecordSymptomDataByDayLocal:dayLocal];
    BOOL isUserFirstSave;
    if (recordData == nil || [[recordData allKeys]count]==0)
    {
        isUserFirstSave = YES;
        //没保存过
        [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:today andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_HistoryUpdatedKey object:nil];
        
        //to sync to remote parse service
        PFObject *parseObjUserRecord = [LZUtility getToSaveParseObject_UserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:today andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
        [parseObjUserRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSMutableString *msg = [NSMutableString string];
            if (succeeded){
                [msg appendFormat:@"PFObject.saveInBackgroundWithBlock OK"];
                [LZUtility saveParseObjectInfo_CurrentUserRecordSymptom_withParseObjectId:parseObjUserRecord.objectId andDayLocal:dayLocal];
            }else{
                [msg appendFormat:@"PFObject.saveInBackgroundWithBlock ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
            }
            NSLog(@"when insertUserRecordSymptom_withDayLocal, %@",msg);
        }];//saveInBackgroundWithBlock
    }
    else
    {
        isUserFirstSave = NO;
    }
    NSDictionary *dataToSave = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:dayLocal],@"dayLocal" ,today,@"date",InputNameValuePairsData,@"InputNameValuePairsData",note,@"note",CalculateNameValuePairsData,@"CalculateNameValuePairsData",nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGHealthReportViewController *healthReportViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGHealthReportViewController"];
    healthReportViewController.isFirstSave = isUserFirstSave;
    healthReportViewController.BMIValue = userBMI;
    healthReportViewController.HealthValue = healthScore;
    healthReportViewController.lackNutritionArray = lackNutritionArray;
    healthReportViewController.potentialArray = illnessAry;
    healthReportViewController.attentionDict = illnessAttentionDict;
    healthReportViewController.recommendFoodDict = recommendedFoods;
    healthReportViewController.dataToSave = dataToSave;
    needRefresh = YES;
    [self.navigationController pushViewController:healthReportViewController animated:YES];
    
}
-(void)userInfoChanged:(NSNotification *)notification
{
    needRefresh = YES;
}
-(void)refresh
{
    needRefresh = NO;
    LZDataAccess *da = [LZDataAccess singleton];
    NSNumber *userSex = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserSexKey];
    if ([userSex intValue]==0)
    {
        symptomTypeRows = [da getSymptomTypeRows_withForSex:ForSex_male];
    }
    else
    {
        symptomTypeRows = [da getSymptomTypeRows_withForSex:ForSex_female];
    }
    
    symptomTypeIdArray = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_SymptomTypeId andDictionaryArray:symptomTypeRows];
    NSLog(@"symptomTypeIds=%@",[LZUtility getObjectDescription:symptomTypeIdArray andIndent:0] );
    symptomRowsDict = [da getSymptomRowsByTypeDict_BySymptomTypeIds:symptomTypeIdArray];
    
    symptomStateDict = [NSMutableDictionary dictionary];
    for (NSString *key in [symptomRowsDict allKeys])
    {
        NSArray *symptomIdRelatedArray = [symptomRowsDict objectForKey:key];
        NSMutableArray *symptomState = [NSMutableArray array];
        for (int i = 0 ; i< [symptomIdRelatedArray count]; i++)
        {
            [symptomState addObject:[NSNumber numberWithBool:NO]];
        }
        [symptomStateDict setObject:symptomState forKey:key];
    }
    [self.userSelectedSymptom removeAllObjects];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    userInputValueDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"",@"note",@"",@"weight",@"",@"heat",@"",@"heartbeat",@"",@"highpressure",@"",@"lowpressure", nil];
    [self.listView reloadData];

}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (needRefresh)
    {
        [self refresh];
    }
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
-(float)calculateHeightForFont:(UIFont *)font maxWidth:(float)maxWidth horizonPadding:(float)horizonPadding verticalPadding:(float)verticalPadding imageMargin:(float)imageMargin bottomMargin:(float)bottomMargin textArray:(NSArray *)textArray
{
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    NSString *queryKey;
    if (isChinese) {
        queryKey =@"SymptomNameCn";
    }
    else
    {
        queryKey = @"SymptomNameEn";
    }

    for (NSDictionary *symptomDict in textArray)
    {
        NSString *text = [symptomDict objectForKey:queryKey];
        CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
        textSize.width += horizonPadding*2;
        textSize.height += verticalPadding*2;
        //UILabel *label = nil;
        CGRect labelFrame;
        if (!gotPreviousFrame) {
            //label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            labelFrame =CGRectMake(0, 0, textSize.width, textSize.height);
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + imageMargin > maxWidth) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + previousFrame.size.height + bottomMargin);
                totalHeight += textSize.height + bottomMargin;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + imageMargin, previousFrame.origin.y);
            }
            newRect.size = textSize;
            labelFrame = newRect;
            //label = [[UILabel alloc] initWithFrame:newRect];
        }
        previousFrame = labelFrame;
        gotPreviousFrame = YES;
//        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
//        if (!lblBackgroundColor) {
//            [label setBackgroundColor:BACKGROUND_COLOR];
//        } else {
//            [label setBackgroundColor:lblBackgroundColor];
//        }
//        [label setTextColor:TEXT_COLOR];
//        [label setText:text];
//        [label setTextAlignment:UITextAlignmentCenter];
//        [label setShadowColor:TEXT_SHADOW_COLOR];
//        [label setShadowOffset:TEXT_SHADOW_OFFSET];
//        [label.layer setMasksToBounds:YES];
//        [label.layer setCornerRadius:CORNER_RADIUS];
//        [label.layer setBorderColor:BORDER_COLOR];
//        [label.layer setBorderWidth: BORDER_WIDTH];
//        [self addSubview:label];
    }
    return totalHeight;
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

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [symptomTypeIdArray count];
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NGMeasurementCell *cell =(NGMeasurementCell*) [self.listView dequeueReusableCellWithIdentifier:@"NGMeasurementCell"];
        [cell.headerNameLabel setBackgroundColor:[UIColor colorWithRed:198/255.f green:212/255.f blue:239/255.f alpha:1.0f]];
        [cell.headerNameLabel.layer setBorderWidth:0.5f];
        [cell.backView.layer setBorderWidth:0.5f];
        [cell.headerNameLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        cell.headerNameLabel.text = [NSString stringWithFormat:@"  %@",NSLocalizedString(@"jiankangjilu_shenglizhibiao", @"生理指标") ];
        cell.heatLabel.text = NSLocalizedString(@"jiankangjilu_tiwen", @"体温");
        cell.weightLabel.text = NSLocalizedString(@"editprofile_weightlabel", @"体重");
        cell.heartbeatLabel.text = NSLocalizedString(@"jiangkangjilu_xintiao", @"心跳");
        cell.highpressureLabel.text = NSLocalizedString(@"jiankangjilu_gaoya", @"高压");
        cell.lowpressureLabel.text = NSLocalizedString(@"jiankangjilu_diya", @"低压");
        cell.heatUnitLabel.text = NSLocalizedString(@"jiankangjilu_sheshidu", @"摄氏度");
        if (isChinese) {
            cell.weightUnitLabel.text = NSLocalizedString(@"jiankangjilu_gongjin", @"公斤");
        }
        else
        {
            cell.weightUnitLabel.text = NSLocalizedString(@"jiankangjilu_bang", @"磅");
        }
        
        cell.heartbeatUnitLabel.text = NSLocalizedString(@"jaingkanjilu_xintiaodanwei", @"次/分钟");
        cell.highpressureUnitLabel.text = NSLocalizedString(@"jiankangjilu_xueyadanwei", @"毫米水银");
        cell.lowpressureUnitLabel.text = NSLocalizedString(@"jiankangjilu_xueyadanwei", @"毫米水银");
        NSString *weight = [self.userInputValueDict objectForKey:@"weight"];
        NSString *heat = [self.userInputValueDict objectForKey:@"heat"];
        NSString *heartbeat = [self.userInputValueDict objectForKey:@"heartbeat"];
        NSString *highpressure = [self.userInputValueDict objectForKey:@"highpressure"];
        NSString *lowpressure = [self.userInputValueDict objectForKey:@"lowpressure"];
        cell.weightTextField.text = weight;
        cell.heatTextField.text = heat;
        cell.heartbeatTextField.text = heartbeat;
        cell.highpressureTextField.text = highpressure;
        cell.lowpressureTextField.text = lowpressure;
        cell.heatTextField.delegate = self;
        cell.weightTextField.delegate = self;
        cell.heartbeatTextField.delegate = self;
        cell.highpressureTextField.delegate = self;
        cell.lowpressureTextField.delegate = self;
        cell.heatTextField.tag = 101;
        cell.weightTextField.tag = 102;
        cell.heartbeatTextField.tag = 103;
        cell.highpressureTextField.tag = 104;
        cell.lowpressureTextField.tag = 105;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        NGNoteCell *cell = (NGNoteCell*)[self.listView dequeueReusableCellWithIdentifier:@"NGNoteCell"];
        [cell.headerNameLabel setBackgroundColor:[UIColor colorWithRed:236/255.f green:171/255.f blue:162/255.f alpha:1.0f]];
        cell.noteTextView.tag = 106;
        [cell.headerNameLabel.layer setBorderWidth:0.5f];
        [cell.backView.layer setBorderWidth:0.5f];
        [cell.headerNameLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        NSString *note = [self.userInputValueDict objectForKey:@"note"];
        cell.noteTextView.text = note;
        cell.headerNameLabel.text = [NSString stringWithFormat:@"  %@",NSLocalizedString(@"jiankangjilu_biji", @"笔记")];;
        cell.noteTextView.delegate = self;
        return cell;
    }
    else
    {
        NGDiagnoseCell *cell = (NGDiagnoseCell*)[self.listView dequeueReusableCellWithIdentifier:@"NGDiagnoseCell"];
        //NSString *symptomTypeId = [self.symptomTypeIdArray objectAtIndex:indexPath.row];
        
        NSDictionary *symptomDict = [symptomTypeRows objectAtIndex:indexPath.row];
        NSString *symptomTypeId = [symptomDict objectForKey:COLUMN_NAME_SymptomTypeId];
        UIColor *selectColor = [LZUtility getSymptomTypeColorForId:symptomTypeId];
        NSString *queryKey;
        if (isChinese)
        {
            queryKey = @"SymptomTypeNameCn";
        }
        else
        {
            queryKey = @"SymptomTypeNameEn";
        }
        NSString *typeStr = [symptomDict objectForKey:queryKey];
        cell.nameLabel.text =[NSString stringWithFormat:@"  %@",typeStr];
        cell.nameLabel.backgroundColor = selectColor;
        cell.nameLabel.layer.borderWidth = 0.5f;
        cell.nameLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:symptomTypeId];
        NSMutableArray *itemStateArray = [self.symptomStateDict objectForKey:symptomTypeId];
        float height = [cell.diagnosesView displayForFont:[UIFont systemFontOfSize:14] maxWidth:280 horizonPadding:6 verticalPadding:4 imageMargin:14 bottomMargin:25 textArray:symptomIdRelatedArray selectedColor:selectColor itemStateArray:itemStateArray isChinese:isChinese];
        cell.backView.frame =CGRectMake(10, 0, 300, height+80);
        cell.diagnosesView.frame = CGRectMake(10, 55, 280, height);
        cell.diagnosesView.cellIndex = indexPath;
        cell.diagnosesView.delegate = self;
        //cell.diagnosesView.backgroundColor = [UIColor blueColor];
        cell.backView.layer.borderWidth = 0.5f;
        cell.backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        return cell;
    }
}
#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1 || indexPath.section ==2)
    {
        return 350;
    }
    else
    {
        NSString *symptomTypeId = [self.symptomTypeIdArray objectAtIndex:indexPath.row];
        NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:symptomTypeId];
        float height =[self calculateHeightForFont:[UIFont systemFontOfSize:14] maxWidth:280 horizonPadding:6 verticalPadding:4 imageMargin:14 bottomMargin:25 textArray:symptomIdRelatedArray]+100;
        return height;
    }
}
#pragma mark- NGDiagnosesViewDelegate
-(void)ItemState:(BOOL )state tag:(int)tag forIndexPath:(NSIndexPath *)indexPath
{
    NSString *symptomTypeId = [self.symptomTypeIdArray objectAtIndex:indexPath.row];
    NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:symptomTypeId];
    NSDictionary *symptomDict = [symptomIdRelatedArray objectAtIndex:tag];

    NSString *text = [symptomDict objectForKey:@"SymptomId"];
    if (state)
    {
        [self.userSelectedSymptom addObject:text];
    }
    else
    {
        [self.userSelectedSymptom removeObject:text];
    }
    if ([self.userSelectedSymptom count]!= 0)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
       
    
}
#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    LZKeyboardToolBar *keyboardToolbar = [[LZKeyboardToolBar alloc]initWithFrame:kKeyBoardToolBarRect doneButtonTitle:NSLocalizedString(@"wanchengbutton",@"完成") delegate:self];
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
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        if (basic)
        {
    if ([string length]+[textField.text length]>5)
    {
        return NO;
    }
    else
    {
        return YES;
    }
        }
        else {
            return NO;
        }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    int tag = textField.tag;
    NSString *content = textField.text;
    switch (tag) {
        case 101:
            [self.userInputValueDict setObject:content forKey:@"heat"];
            break;
        case 102:
            [self.userInputValueDict setObject:content forKey:@"weight"];
            break;
        case 103:
            [self.userInputValueDict setObject:content forKey:@"heartbeat"];
            break;
        case 104:
            [self.userInputValueDict setObject:content forKey:@"highpressure"];
            break;
        case 105:
            [self.userInputValueDict setObject:content forKey:@"lowpressure"];
            break;
        default:
            break;
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
#pragma mark- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    LZKeyboardToolBar *keyboardToolbar = [[LZKeyboardToolBar alloc]initWithFrame:kKeyBoardToolBarRect doneButtonTitle:NSLocalizedString(@"wanchengbutton",@"完成") delegate:self];
    textView.inputAccessoryView = keyboardToolbar;
    self.currentTextView = textView;
    return YES;

}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    int tag = textView.tag;
    NSString *content = textView.text;
    
    if (tag == 106)
    {
        [self.userInputValueDict setObject:content forKey:@"note"];
    }
}

#pragma mark- LZKeyboardToolBarDelegate
-(void)toolbarKeyboardDone
{
    if(self.currentTextField)
    {
        [self.currentTextField resignFirstResponder];
    }
    if (self.currentTextView)
    {
        [self.currentTextView resignFirstResponder];
    }
}
@end
