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
#import "NGDiagnoseLabel.h"
#import "GADMasterViewController.h"
@interface NGDiagnoseViewController ()<LZKeyboardToolBarDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    BOOL isChinese;
}
@property (strong,nonatomic) UITextField *currentTextField;
@property (strong,nonatomic) UITextView *currentTextView;
@property (strong,nonatomic) NSMutableDictionary *userInputValueDict;
@property (strong,nonatomic) NSArray *symptomTypeRows;
@property (assign,nonatomic)BOOL needRefresh;
@property (assign,nonatomic)BOOL needClearState;
@property (strong,nonatomic)NSMutableDictionary *symptomRowHeightDict;
@property (nonatomic,strong) NSMutableDictionary *diagnoseViewDict;
@property (nonatomic,strong)UIView *adView;
@end

@implementation NGDiagnoseViewController
@synthesize symptomTypeIdArray,symptomRowsDict,symptomStateDict,currentTextField,userInputValueDict,userSelectedSymptom,needRefresh,symptomTypeRows,symptomRowHeightDict,needClearState,diagnoseViewDict;
@synthesize adView;
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
    self.navigationItem.title = NSLocalizedString(@"jiankangjilu_c_navtitle", @"页面的标题：选择症状");
    NSString *headerMessage =NSLocalizedString(@"jiankangjilu_c_header", @"页面表头：选择您今天的症状，然后点击查看养生报告。");
    CGSize headerSize = [headerMessage sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 999) lineBreakMode:UILineBreakModeWordWrap];

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, headerSize.height+10)];
    [headerView setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, (int)headerSize.width+1, headerSize.height)];
    [label setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setNumberOfLines:0];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setText:headerMessage];
    symptomRowHeightDict = [[NSMutableDictionary alloc]init];
    diagnoseViewDict = [[NSMutableDictionary alloc]init];
    [label setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    [headerView addSubview:label];
    self.listView.tableHeaderView = headerView;
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    UIBarButtonItem *submitItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"jiankangjilu_c_chakan", @"页面查看按钮：查看") style:UIBarButtonItemStyleBordered target:self action:@selector(getHealthReport)];
    [submitItem setEnabled:NO];
    self.navigationItem.rightBarButtonItem = submitItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged:) name:Notification_SettingsChangedKey object:nil];
    isChinese =[LZUtility isCurrentLanguageChinese];
    userSelectedSymptom = [[NSMutableArray alloc]init];
    needRefresh = NO;
    needClearState = NO;
    [self refresh];
    self.adView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.adView setBackgroundColor:[UIColor clearColor]];
    self.listView.tableFooterView = self.adView;
    
    	// Do any additional setup after loading the view.
}
-(void)clearState
{
    needClearState = NO;
    for (NSString *key in [symptomRowsDict allKeys])
    {
        NSArray *symptomIdRelatedArray = [symptomRowsDict objectForKey:key];
        NSMutableArray *symptomState = [NSMutableArray array];
//        float height =[self calculateHeightForFont:[UIFont systemFontOfSize:14] maxWidth:280 horizonPadding:6 verticalPadding:4 imageMargin:14 bottomMargin:25 textArray:symptomIdRelatedArray]+100;
//        [symptomRowHeightDict setObject:[NSNumber numberWithFloat:height] forKey:key];
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
-(void)refresh
{
    
    needRefresh = NO;
    needClearState = NO;
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
    //NSLog(@"symptomTypeIds=%@",[LZUtility getObjectDescription:symptomTypeIdArray andIndent:0] );
    symptomRowsDict = [da getSymptomRowsByTypeDict_BySymptomTypeIds:symptomTypeIdArray];
    
    symptomStateDict = [NSMutableDictionary dictionary];
    for (NSString *key in [symptomRowsDict allKeys])
    {
        NSArray *symptomIdRelatedArray = [symptomRowsDict objectForKey:key];
        NSMutableArray *symptomState = [NSMutableArray array];
        NSNumber* heightNum =[self calculateHeightForFont:[UIFont systemFontOfSize:14] maxWidth:280 horizonPadding:10 verticalPadding:7 imageMargin:10 bottomMargin:25 textArray:symptomIdRelatedArray typeId:key];
        [symptomRowHeightDict setObject:heightNum forKey:key];
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
    if (![self checkSubmitItemEnableState])
    {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGHealthReportViewController *healthReportViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGHealthReportViewController"];
    NSMutableArray *symptomsByTypeArray = [[NSMutableArray alloc]init];
    for (NSDictionary *symptomTypeDict in symptomTypeRows)
    {
        NSString *symptomTypeId = [symptomTypeDict objectForKey:COLUMN_NAME_SymptomTypeId];
        NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:symptomTypeId];
        NSMutableArray *itemStateArray = [self.symptomStateDict objectForKey:symptomTypeId];
        NSMutableArray *selectSymtomArray = [[NSMutableArray alloc]init];
        for (int i = 0;i<[itemStateArray count];i++)
        {
            NSNumber *state = [itemStateArray objectAtIndex:i];
            if ([state boolValue])
            {
                NSDictionary *symtomDict = [symptomIdRelatedArray objectAtIndex:i];
                NSString *symtomId = [symtomDict objectForKey:@"SymptomId"];
                [selectSymtomArray addObject:symtomId];
            }
        }
        if ([selectSymtomArray count]!=0)
        {
            NSArray *aSymptomsByType = [[NSArray alloc]initWithObjects:symptomTypeId,selectSymtomArray, nil];
            [symptomsByTypeArray addObject:aSymptomsByType];
        }
    }
    healthReportViewController.userInputValueDict = userInputValueDict;
    healthReportViewController.userSelectedSymptom = userSelectedSymptom;
    healthReportViewController.symptomsByTypeArray = symptomsByTypeArray;
    healthReportViewController.isOnlyDisplay = NO;
    needClearState = YES;
    [self.navigationController pushViewController:healthReportViewController animated:YES];
}
-(void)userInfoChanged:(NSNotification *)notification
{
    needRefresh = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    GADMasterViewController *gad = [GADMasterViewController singleton];
    [gad resetAdView:self andListView:self.adView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (needRefresh)
    {
        [self refresh];
    }
    else if(needClearState)
    {
        [self clearState];
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

-(BOOL)checkSubmitItemEnableState
{
    BOOL hasInput = NO;
    for (NSString *key in [self.userInputValueDict allKeys])
    {
        NSString *value = [self.userInputValueDict objectForKey:key];
        if ([value length]!=0)
        {
            hasInput = YES;
            break;
        }
    }
    if (hasInput || [self.userSelectedSymptom count]!= 0)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return YES;
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        return NO;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSNumber *)calculateHeightForFont:(UIFont *)font maxWidth:(float)maxWidth horizonPadding:(float)horizonPadding verticalPadding:(float)verticalPadding imageMargin:(float)imageMargin bottomMargin:(float)bottomMargin textArray:(NSArray *)textArray typeId:(NSString*)typeId
{
    
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    NSString *queryKey;
    //NSMutableArray *heightArray = [[NSMutableArray alloc]init];
    UIView *diagnoseView = [[UIView alloc]initWithFrame:CGRectZero];
    if (isChinese) {
        queryKey =@"SymptomNameCn";
    }
    else
    {
        queryKey = @"SymptomNameEn";
    }

    for (int i =0;i< [textArray count];i++)
    {
        NSDictionary *symptomDict = [textArray objectAtIndex:i];
        NSString *text = [symptomDict objectForKey:queryKey];
        CGSize originTextSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
        //NSLog(@"begin%f",textSize.height);
        CGSize textSize = CGSizeMake((int)originTextSize.width, (int)originTextSize.height);
        textSize.width += horizonPadding*2;
        textSize.height += verticalPadding*2;
        //NSLog(@"after%f",textSize.height);
        //[heightArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:textSize.width],@"TextSizeWidth",[NSNumber numberWithFloat:textSize.height],@"TextSizeHeight", nil]];
        //UILabel *label = nil;
        NGDiagnoseLabel *label = nil;
        if (!gotPreviousFrame) {
            //label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            label = [[NGDiagnoseLabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
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
            label = [[NGDiagnoseLabel alloc] initWithFrame:newRect];
            //label = [[UILabel alloc] initWithFrame:newRect];
        }
        //NSLog(@"%f,%f",label.frame.size.width,label.frame.size.height);
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setFont:font];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTappedDiagnose:)];
        [label addGestureRecognizer:tap];
        label.numberOfLines = 0;

        [label setTextColor:[UIColor blackColor]];
        [label setText:text];
        [label setOpaque:YES];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setTextAlignment:UITextAlignmentCenter];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:5];
        label.tag = i+10;
        label.customTag = typeId;
        
        [diagnoseView addSubview:label];
    }
    [diagnoseView setFrame:CGRectMake(10, 10, 280, totalHeight) ];
    [self.diagnoseViewDict setObject:diagnoseView forKey:typeId];
    //[heightArray insertObject:[NSNumber numberWithFloat:totalHeight] atIndex:0];
    return [NSNumber numberWithFloat:totalHeight];
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
        if (!cell.hasLoaded)
        {
            [cell.headerNameLabel setBackgroundColor:[UIColor colorWithRed:198/255.f green:212/255.f blue:239/255.f alpha:1.0f]];
            [cell.headerNameLabel.layer setBorderWidth:0.5f];
            [cell.backView.layer setBorderWidth:0.5f];
            [cell.headerNameLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            cell.headerNameLabel.text = [NSString stringWithFormat:@"  %@",NSLocalizedString(@"jiankangjilu_c_shenglizhibiao", @"指标栏标题：生理指标") ];
            cell.heatLabel.text = NSLocalizedString(@"jiankangjilu_c_tiwen", @"体温项标题：体温");
            cell.weightLabel.text = NSLocalizedString(@"jiankangjilu_c_tizhong", @"体重项标题：体重");
            cell.heartbeatLabel.text = NSLocalizedString(@"jiangkangjilu_c_xintiao", @"心跳项标题：心跳");
            cell.highpressureLabel.text = NSLocalizedString(@"jiankangjilu_c_gaoya", @"高压项标题：高压");
            cell.lowpressureLabel.text = NSLocalizedString(@"jiankangjilu_c_diya", @"低压项标题：低压");
            
            if (isChinese) {
                cell.weightUnitLabel.text = NSLocalizedString(@"jiankangjilu_c_gongjin", @"体重项单位：公斤");
                cell.heatUnitLabel.text = NSLocalizedString(@"jiankangjilu_c_sheshidu", @"体温项单位：摄氏度");
                cell.weightTextField.placeholder = @"76";
                cell.heatTextField.placeholder = @"37";
            }
            else
            {
                cell.weightUnitLabel.text = NSLocalizedString(@"jiankangjilu_c_bang", @"体重项单位：磅");
                cell.heatUnitLabel.text = NSLocalizedString(@"jiankangjilu_c_huashidu", @"体温项单位：华氏度");
                cell.weightTextField.placeholder = @"168";
                cell.heatTextField.placeholder = @"99";
            }
            
            cell.heartbeatUnitLabel.text = NSLocalizedString(@"jaingkanjilu_c_xintiaodanwei", @"心跳项单位：次/分钟");
            cell.highpressureUnitLabel.text = NSLocalizedString(@"jiankangjilu_c_xueyadanwei", @"血压项单位：毫米水银");
            cell.lowpressureUnitLabel.text = NSLocalizedString(@"jiankangjilu_c_xueyadanwei", @"血压项单位：毫米水银");
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
            cell.hasLoaded = YES;
        }
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
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        NGNoteCell *cell = (NGNoteCell*)[self.listView dequeueReusableCellWithIdentifier:@"NGNoteCell"];
        if (!cell.hasLoaded) {
            [cell.headerNameLabel setBackgroundColor:[UIColor colorWithRed:236/255.f green:171/255.f blue:162/255.f alpha:1.0f]];
            cell.noteTextView.tag = 106;
            [cell.headerNameLabel.layer setBorderWidth:0.5f];
            [cell.backView.layer setBorderWidth:0.5f];
            [cell.headerNameLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            cell.headerNameLabel.text = [NSString stringWithFormat:@"  %@",NSLocalizedString(@"jiankangjilu_c_biji", @"笔记栏标题：笔记")];;
            cell.noteTextView.delegate = self;
            cell.hasLoaded = YES;
        }
        NSString *note = [self.userInputValueDict objectForKey:@"note"];
        cell.noteTextView.text = note;
        
        return cell;
    }
    else
    {
        NGDiagnoseCell *cell = (NGDiagnoseCell*)[self.listView dequeueReusableCellWithIdentifier:@"NGDiagnoseCell"];
        NSString *symptomTypeId = [self.symptomTypeIdArray objectAtIndex:indexPath.row];
        NSDictionary *symptomDict = [symptomTypeRows objectAtIndex:indexPath.row];
        //NSString *symptomTypeId = [symptomDict objectForKey:COLUMN_NAME_SymptomTypeId];
        UIView *viewToRemove = [cell.backView viewWithTag:1];
        if (viewToRemove!= nil)
        {
            [viewToRemove removeFromSuperview];
        }
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
        UIView *diagnoseView = [self.diagnoseViewDict objectForKey:symptomTypeId];
        
        NSString *typeStr = [symptomDict objectForKey:queryKey];
        cell.nameLabel.text =[NSString stringWithFormat:@"  %@",typeStr];
        cell.nameLabel.backgroundColor = selectColor;
        cell.nameLabel.layer.borderWidth = 0.5f;
        cell.nameLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        NSNumber *heightNum = [self.symptomRowHeightDict objectForKey:symptomTypeId];
        NSMutableArray *itemStateArray = [self.symptomStateDict objectForKey:symptomTypeId];
        //NSLog(@"begin state");
        for (int i=0; i<[itemStateArray count] ; i++)
        {
            NSNumber *state = [itemStateArray objectAtIndex:i];
            NGDiagnoseLabel *label = (NGDiagnoseLabel*)[diagnoseView viewWithTag:i+10];
            if ([state boolValue])
            {
                [label setBackgroundColor:selectColor];
            }
            else
            {
                [label setBackgroundColor:[UIColor whiteColor]];
            }

        }
        
        float height = [heightNum floatValue];
        cell.backView.frame =CGRectMake(10, 0, 300, height+80);
        
        [cell.backView addSubview:diagnoseView];
        [diagnoseView setFrame:CGRectMake(10, 55, 280, height)];
        diagnoseView.tag = 1;
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
        NSNumber *heightNum = [self.symptomRowHeightDict objectForKey:symptomTypeId];
        if (heightNum != nil)
        {
            return [heightNum floatValue]+100;
        }
        else
        {
            NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:symptomTypeId];
            
            NSNumber* newHeight =[self calculateHeightForFont:[UIFont systemFontOfSize:14] maxWidth:280 horizonPadding:10 verticalPadding:7 imageMargin:10 bottomMargin:25 textArray:symptomIdRelatedArray typeId:symptomTypeId];
            [self.symptomRowHeightDict setObject:newHeight forKey:symptomTypeId];
            return [newHeight floatValue]+100;
        }
    }
}
-(void)userTappedDiagnose:(UITapGestureRecognizer*)sender
{
    NGDiagnoseLabel *label = (NGDiagnoseLabel *)sender.view;
    int tag = label.tag-10;
    NSString *typeId = (NSString*)label.customTag;
    UIColor *selectColor = [LZUtility getSymptomTypeColorForId:typeId];
    NSMutableArray *itemStateArray = [self.symptomStateDict objectForKey:typeId];
    NSNumber *state = [itemStateArray objectAtIndex:tag];
    NSNumber *newState;
    if ([state boolValue])
    {
        newState = [NSNumber numberWithBool:NO];
        [label setBackgroundColor:[UIColor clearColor]];
        [label.layer setBorderColor:[UIColor clearColor].CGColor];
    }
    else
    {
        newState = [NSNumber numberWithBool:YES];
        [label setBackgroundColor:selectColor];
        [label.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }
    [itemStateArray replaceObjectAtIndex:tag withObject:newState];
    NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:typeId];
    NSDictionary *symptomDict = [symptomIdRelatedArray objectAtIndex:tag];
    
    NSString *text = [symptomDict objectForKey:@"SymptomId"];
    if ([newState boolValue])
    {
        [self.userSelectedSymptom addObject:text];
    }
    else
    {
        [self.userSelectedSymptom removeObject:text];
    }
    [self checkSubmitItemEnableState];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(ItemState:tag:forIndexPath:)])
//    {
//        [self.delegate ItemState:[newState boolValue] tag:tag forIndexPath:self.cellIndex];
//    }
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
    [self checkSubmitItemEnableState];
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
    [self checkSubmitItemEnableState];
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
