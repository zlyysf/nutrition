//
//  NGHealthReportViewController.m
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGHealthReportViewController.h"
#import "NGRecommendFoodView.h"
#define NutritionItemLabelHeight 36
#define NutritionItemStartX 107
#define NutritionItemStartY 95
#define NutritionItemMargin 14
#define ItemTopMargin 12
#define PotentialItemLabelWidth 188
#define AttentionItemOrderlabelWidth 12
#define PotentialItemMargin 9
#define AttentionItemMargin 8
#define BottomViewBottomMargin 25
#define ItemDetailArrowStartX 255
#define AttentionLabelStartX 86
#define RecommendScrollViewHeight 150
#define RecommendFoodMargin 14
#define RecommendFoodStartY 15
#define BigLabelFont [UIFont systemFontOfSize:22.f]
#define SmallLabelFont [UIFont systemFontOfSize:14.f]
@interface NGHealthReportViewController ()
@property (nonatomic,assign)BOOL isFirstLoad;
@end

@implementation NGHealthReportViewController
@synthesize lackNutritionArray,potentialArray,attentionArray,isFirstLoad;
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
    [self.mainScrollView setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]];
    isFirstLoad = YES;
    self.lackNutritionArray = [NSArray arrayWithObjects:@"锌",@"铁",@"蛋白质",@"维生素B12",nil];
    self.potentialArray = [NSArray arrayWithObjects:@"急性咽炎",@"关节炎",@"流行性感冒",nil ];
    self.attentionArray = [NSArray arrayWithObjects:@"少吃熏制，腌制，富含硝酸盐的食品",@"避免大量饮酒，吸烟",@"充分睡眠",@"多饮水，保持室内空气流通",nil ];
    NSDictionary *food1 = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                                       @"鸡蛋",@"foodname",
                                                                       @"干果.png",@"foodpic",
                                                                       @"2个",@"foodamount", nil];
    NSDictionary *food2 = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                                       @"开心果",@"foodname",
                                                                       @"干果.png",@"foodpic",
                                                                       @"50克",@"foodamount", nil];
    NSDictionary *food3 = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                                       @"生蚝",@"foodname",
                                                                       @"干果.png",@"foodpic",
                                                                       @"2个",@"foodamount", nil];
    NSDictionary *food4 = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                                       @"西兰花",@"foodname",
                                                                       @"干果.png",@"foodpic",
                                                                       @"100g",@"foodamount", nil];
    NSDictionary *food5 = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                                       @"菠菜",@"foodname",
                                                                       @"干果.png",@"foodpic",
                                                                       @"200克",@"foodamount", nil];
    self.recommendFoodArray = [NSArray arrayWithObjects:food1,food2,food3,food4,food5,nil];
    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        [self displayReport];
    }
}
-(void)displayReport
{
    float totalheight = 0;
    float starty = 120;
    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.topView.layer.borderWidth = 0.5f;
    self.middleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.middleView.layer.borderWidth = 0.5f;
    self.bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bottomView.layer.borderWidth = 0.5f;
    self.BMILabel.text = @"体质指数";
    self.BMIScoreLabel.text = @"25.1";
    self.BMIDescriptionLabel.text = @"超重了";
    [self.BMIProgressBar setProgress:0.5f];
    self.nutritionLevelLabel.text = @"营养指数";
    self.nutritionScoreLabel.text = @"89";
    self.lackNutritonLabel.text = @"缺乏营养";
    self.recommendFoodLabel.text = @"推荐食物";
    self.potentialLabel.text = @"潜在疾病";
    self.attentionLabel.text = @"注意事项";
    int lackCount =[self.lackNutritionArray count];
    float middleViewHeight = NutritionItemStartY+ lackCount*NutritionItemLabelHeight+2*ItemTopMargin+(lackCount -1)*NutritionItemMargin+185;
    [self.lackNutritonLabel setFrame:CGRectMake(10, NutritionItemStartY+(lackCount*NutritionItemLabelHeight+2*ItemTopMargin+(lackCount -1)*NutritionItemMargin-20)/2, 60, 20)];
    [self.middleView setFrame:CGRectMake(10, starty, 300, middleViewHeight)];
    for (int i=0 ; i< lackCount; i++)
    {
        UILabel *lackItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(NutritionItemStartX, NutritionItemStartY+ItemTopMargin+i*(NutritionItemLabelHeight+NutritionItemMargin), 140, NutritionItemLabelHeight)];
        [self.middleView addSubview:lackItemLabel];
        lackItemLabel.text = [self.lackNutritionArray objectAtIndex:i];
        [lackItemLabel setFont:BigLabelFont];
        [lackItemLabel setTextColor:[UIColor blackColor]];
        [lackItemLabel setBackgroundColor:[UIColor clearColor]];
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(ItemDetailArrowStartX, 0, 20, 20)];
        [self.middleView addSubview:arrowImage];
        CGPoint lackLabelCenter = lackItemLabel.center;
        CGPoint arrowCenter = CGPointMake(arrowImage.center.x, lackLabelCenter.y);
        arrowImage.center = arrowCenter;
        [arrowImage setImage:[UIImage imageNamed:@"item_detail_arrow.png"]];
    }
    int foodCount =[self.recommendFoodArray count];
    [self.recommendFoodScrollView setContentSize:CGSizeMake(2+foodCount*(80+RecommendFoodMargin)-RecommendFoodMargin, RecommendScrollViewHeight)];
    for (int l=0; l< foodCount; l++)
    {
        NSDictionary *foodInfo = [self.recommendFoodArray objectAtIndex:l];
        NGRecommendFoodView *foodView = [[NGRecommendFoodView alloc]initWithFrame:CGRectMake(1+l*(80+RecommendFoodMargin), 15, 80, 120) foodInfo:foodInfo];
        [self.recommendFoodScrollView addSubview:foodView];
    }
    
    int potentialCount = [self.potentialArray count];
    float bottomPart1Height = ItemTopMargin+potentialCount*(NutritionItemLabelHeight+PotentialItemMargin)+BottomViewBottomMargin-PotentialItemMargin;
    [self.potentialLabel setFrame:CGRectMake(10, (bottomPart1Height-20-(BottomViewBottomMargin-ItemTopMargin))/2, 60, 20)];
    for (int j =0 ; j< potentialCount; j++)
    {
        UILabel *potentialItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(NutritionItemStartX, ItemTopMargin+j*(NutritionItemLabelHeight+PotentialItemMargin), 140, NutritionItemLabelHeight)];
        [self.bottomView addSubview:potentialItemLabel];
        potentialItemLabel.text = [self.potentialArray objectAtIndex:j];
        [potentialItemLabel setFont:BigLabelFont];
        [potentialItemLabel setTextColor:[UIColor blackColor]];
        [potentialItemLabel setBackgroundColor:[UIColor clearColor]];
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(ItemDetailArrowStartX, 0, 20, 20)];
        [self.bottomView addSubview:arrowImage];
        CGPoint potentialLabelCenter = potentialItemLabel.center;
        CGPoint arrowCenter = CGPointMake(arrowImage.center.x, potentialLabelCenter.y);
        arrowImage.center = arrowCenter;
        [arrowImage setImage:[UIImage imageNamed:@"item_detail_arrow.png"]];
    }
    [self.bottomSepLine setFrame:CGRectMake(0, bottomPart1Height, 300, 1)];
    int attentionCount = [self.attentionArray count];
    float bottomPart2Height = 0;
    float attentionStartY = bottomPart1Height+ItemTopMargin;

    float onelineHeight = [@"o" sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(PotentialItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    for (int k = 0; k<attentionCount; k++)
    {
        NSString *text = [self.attentionArray objectAtIndex:k];
        CGSize textSize = [text sizeWithFont:SmallLabelFont constrainedToSize:CGSizeMake(PotentialItemLabelWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
        UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(AttentionLabelStartX, attentionStartY, AttentionItemOrderlabelWidth, onelineHeight)];
        [orderLabel setFont:SmallLabelFont];
        [orderLabel setText:[NSString stringWithFormat:@"%d.",k+1]];
        [orderLabel setTextColor:[UIColor blackColor]];
        [self.bottomView addSubview:orderLabel];
        UILabel *attentionItemLabel = [[UILabel  alloc]initWithFrame:CGRectMake(AttentionLabelStartX+AttentionItemOrderlabelWidth,attentionStartY, textSize.width, textSize.height)];
        [attentionItemLabel setBackgroundColor:[UIColor clearColor]];
        [attentionItemLabel setFont:SmallLabelFont];
        [attentionItemLabel setNumberOfLines:0];
        [attentionItemLabel setText:text];
        [attentionItemLabel setTextColor:[UIColor blackColor]];
        [self.bottomView addSubview:attentionItemLabel];
        attentionStartY += (textSize.height+AttentionItemMargin);
    }

    float bottomViewHeight = attentionStartY+BottomViewBottomMargin-AttentionItemMargin;
    bottomPart2Height = bottomViewHeight-bottomPart1Height;
    [self.attentionLabel setFrame:CGRectMake(10, bottomPart1Height+(bottomPart2Height-20-(BottomViewBottomMargin-ItemTopMargin))/2, 60, 20)];
    [self.bottomView setFrame:CGRectMake(10, starty+middleViewHeight+40, 300, bottomViewHeight)];
    totalheight = 120+middleViewHeight+40+bottomViewHeight+20;
    [self.mainScrollView setContentSize:CGSizeMake(320, totalheight)];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
