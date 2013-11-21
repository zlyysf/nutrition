//
//  NGDiagnoseViewController.m
//  nutrition
//
//  Created by liu miao on 11/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGDiagnoseViewController.h"
#import "NGDiagnoseCell.h"
@interface NGDiagnoseViewController ()<NGDiagnosesViewDelegate>

@end

@implementation NGDiagnoseViewController
@synthesize diagnosesArray;
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
    self.diagnosesArray = [NSArray arrayWithObjects:@"头晕",@"头疼",@"头发干枯",@"头发脱落",@"脸色苍白",@"脸下垂", @"裂口",@"脸抽搐",@"老年斑",@"眉间出油",@"颜面水肿",nil];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 22)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 22)];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setText:@"今天哪里不舒服吗？点击记录一下吧。"];
    [label setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.listView.tableHeaderView = headerView;
    self.listView.tableFooterView = footerView;
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
    for (NSString *text in textArray) {
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
    return 12;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 10)
    {
         UITableViewCell *cell = [self.listView dequeueReusableCellWithIdentifier:@"MeasurementCell"];
        return cell;
    }
    else if (indexPath.row == 11)
    {
        UITableViewCell *cell = [self.listView dequeueReusableCellWithIdentifier:@"NoteCell"];
        return cell;
    }
    else
    {
        NGDiagnoseCell *cell = (NGDiagnoseCell*)[self.listView dequeueReusableCellWithIdentifier:@"NGDiagnoseCell"];
        cell.nameLabel.text =@"  头面";
        cell.nameLabel.backgroundColor = [UIColor redColor];
        float height = [cell.diagnosesView displayForFont:[UIFont systemFontOfSize:18] maxWidth:280 horizonPadding:4 verticalPadding:4 imageMargin:8 bottomMargin:15 textArray:self.diagnosesArray selectedColor:[UIColor redColor]];
        cell.backView.frame =CGRectMake(10, 10, 300, height+50);
        cell.diagnosesView.frame = CGRectMake(10, 40, 280, height);
        cell.diagnosesView.cellIndex = indexPath;
        cell.diagnosesView.delegate = self;
        //cell.diagnosesView.backgroundColor = [UIColor blueColor];
        cell.backView.layer.borderWidth = 0.5f;
        cell.backView.layer.borderColor = [UIColor grayColor].CGColor;
        return cell;
    }
}
#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 10 || indexPath.row == 11)
    {
        return 200;
    }
    return [self calculateHeightForFont:[UIFont systemFontOfSize:18] maxWidth:280 horizonPadding:4 verticalPadding:4 imageMargin:8 bottomMargin:15 textArray:self.diagnosesArray]+60;
}
#pragma mark- NGDiagnosesViewDelegate
-(void)userSelectedItem:(NSString *)text forIndexPath:(NSIndexPath*)indexPath
{
    NSString *message = [NSString stringWithFormat:@"您点击的症状是 %@, cell index section: %d row :%d",text,indexPath.section,indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
