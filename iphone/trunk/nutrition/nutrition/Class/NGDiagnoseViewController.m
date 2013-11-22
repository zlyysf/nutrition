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
@interface NGDiagnoseViewController ()<NGDiagnosesViewDelegate>

@end

@implementation NGDiagnoseViewController
@synthesize symptomTypeIdArray,symptomRowsDict,symptomStateDict;
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
#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [symptomTypeIdArray count]+2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.symptomTypeIdArray count])
    {
        UITableViewCell *cell = [self.listView dequeueReusableCellWithIdentifier:@"MeasurementCell"];
        UIView *titleView = [cell.contentView viewWithTag:1];
        UIView *backView = [cell.contentView viewWithTag:2];
        [titleView.layer setBorderWidth:0.5f];
        [backView.layer setBorderWidth:0.5f];
        [titleView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        return cell;
    }
    else if (indexPath.row == [self.symptomTypeIdArray count]+1)
    {
        UITableViewCell *cell = [self.listView dequeueReusableCellWithIdentifier:@"NoteCell"];
        UIView *titleView = [cell.contentView viewWithTag:1];
        UIView *backView = [cell.contentView viewWithTag:2];
        [titleView.layer setBorderWidth:0.5f];
        [backView.layer setBorderWidth:0.5f];
        [titleView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
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
    if (indexPath.row >= [self.symptomTypeIdArray count])
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
    if (state)
    {
        NSString *symptomTypeId = [self.symptomTypeIdArray objectAtIndex:indexPath.row];
        NSArray *symptomIdRelatedArray = [self.symptomRowsDict objectForKey:symptomTypeId];
        NSMutableArray *itemStateArray = [self.symptomStateDict objectForKey:symptomTypeId];

        NSDictionary *symptomDict = [symptomIdRelatedArray objectAtIndex:tag];
        NSString *text = [symptomDict objectForKey:@"SymptomNameCn"];
        NSString *message = [NSString stringWithFormat:@"您点击的症状是 %@, cell index section: %d row :%d",text,indexPath.section,indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}
@end
