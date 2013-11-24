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
@interface NGDiagnoseViewController ()<NGDiagnosesViewDelegate,LZKeyboardToolBarDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic) UITextField *currentTextField;
@property (strong,nonatomic) UITextView *currentTextView;
@end

@implementation NGDiagnoseViewController
@synthesize symptomTypeIdArray,symptomRowsDict,symptomStateDict,currentTextField;
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
    self.title = @"健康记录";
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 4, 280, 21)];
    [label setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setText:@"今天哪里不舒服吗？点击记录一下吧。"];
    [label setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label];
    self.listView.tableHeaderView = headerView;
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *symptomTypeRows = [da getSymptomTypeRows_withForSex:ForSex_female];
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
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
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
-(float)calculateHeightForFont:(UIFont *)font maxWidth:(float)maxWidth horizonPadding:(float)horizonPadding verticalPadding:(float)verticalPadding imageMargin:(float)imageMargin bottomMargin:(float)bottomMargin textArray:(NSArray *)textArray
{
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSDictionary *symptomDict in textArray)
    {
        NSString *text = [symptomDict objectForKey:@"SymptomNameCn"];
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
        cell.headerNameLabel.text = @"  测量";
        cell.heatLabel.text = @"体温";
        cell.weightLabel.text = @"体重";
        cell.heartbeatLabel.text = @"心跳";
        cell.highpressureLabel.text = @"高压";
        cell.lowpressureLabel.text = @"低压";
        cell.heatUnitLabel.text = @"摄氏度";
        cell.weightUnitLabel.text = @"公斤";
        cell.heartbeatUnitLabel.text = @"次/分钟";
        cell.highpressureUnitLabel.text = @"毫米水银";
        cell.lowpressureUnitLabel.text = @"毫米水银";
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
        cell.headerNameLabel.text = @"  笔记";
        cell.noteTextView.delegate = self;
        return cell;
    }
    else
    {
        NGDiagnoseCell *cell = (NGDiagnoseCell*)[self.listView dequeueReusableCellWithIdentifier:@"NGDiagnoseCell"];
        NSString *symptomTypeId = [self.symptomTypeIdArray objectAtIndex:indexPath.row];
        UIColor *selectColor = [LZUtility getSymptomTypeColorForId:symptomTypeId];
        cell.nameLabel.text =[NSString stringWithFormat:@"  %@",symptomTypeId];
        cell.nameLabel.backgroundColor = selectColor;
        cell.nameLabel.layer.borderWidth = 0.5f;
        cell.nameLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:symptomTypeId];
        NSMutableArray *itemStateArray = [self.symptomStateDict objectForKey:symptomTypeId];
        float height = [cell.diagnosesView displayForFont:[UIFont systemFontOfSize:14] maxWidth:280 horizonPadding:6 verticalPadding:4 imageMargin:14 bottomMargin:25 textArray:symptomIdRelatedArray selectedColor:selectColor itemStateArray:itemStateArray];
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
//    if (state)
//    {
//        NSString *symptomTypeId = [self.symptomTypeIdArray objectAtIndex:indexPath.row];
//        NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:symptomTypeId];
//        NSDictionary *symptomDict = [symptomIdRelatedArray objectAtIndex:tag];
//        NSString *text = [symptomDict objectForKey:@"SymptomNameCn"];
//        NSString *message = [NSString stringWithFormat:@"您点击的症状是 %@, cell index section: %d row :%d",text,indexPath.section,indexPath.row];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
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
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        if (basic)
        {
    if ([string length]+[textField.text length]>3)
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
    NSNumber *number = [NSNumber numberWithInt:[textField.text intValue]];
    NSString *message;
    switch (tag) {
        case 101:
            message = @"体温";
            break;
        case 102:
            message = @"体重";
            break;
        case 103:
            message = @"心跳";
            break;
        case 104:
            message = @"高压";
            break;
        case 105:
            message = @"低压";
            break;
            
        default:
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@%d",message,[number intValue]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
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
    if (tag == 106)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:textView.text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
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
