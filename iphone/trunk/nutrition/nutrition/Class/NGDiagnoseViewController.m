//
//  NGDiagnoseViewController.m
//  nutrition
//
//  Created by liu miao on 11/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGDiagnoseViewController.h"
#import "NGDiagnoseCell.h"
@interface NGDiagnoseViewController ()

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
    self.diagnosesArray = [NSArray arrayWithObjects:@"症状1",@"症状2blalbalba",@"症状3lala",@"症状4bla",@"症状5blalblalbla",@"症状6lblalalallalala", nil];
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
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + bottomMargin);
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
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NGDiagnoseCell *cell = (NGDiagnoseCell*)[self.listView dequeueReusableCellWithIdentifier:@"NGDiagnoseCell"];
    cell.nameLabel.text = [NSString stringWithFormat:@"  项目%d ",indexPath.row+1];
    cell.nameLabel.backgroundColor = [UIColor redColor];
    float height = [cell.diagnosesView displayForFont:[UIFont systemFontOfSize:18] maxWidth:280 horizonPadding:2 verticalPadding:2 imageMargin:5 bottomMargin:8 textArray:self.diagnosesArray selectedColor:[UIColor redColor]];
    cell.backView.frame =CGRectMake(10, 10, 300, height+50);
    cell.diagnosesView.frame = CGRectMake(10, 40, 280, height);
    cell.diagnosesView.backgroundColor = [UIColor blueColor];
    cell.backView.layer.borderWidth = 0.5f;
    cell.backView.layer.borderColor = [UIColor grayColor].CGColor;
    return cell;
}
#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateHeightForFont:[UIFont systemFontOfSize:18] maxWidth:280 horizonPadding:2 verticalPadding:2 imageMargin:5 bottomMargin:8 textArray:self.diagnosesArray]+60;
}

@end
