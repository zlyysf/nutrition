//
//  NGFoodListViewController.m
//  nutrition
//
//  Created by liu miao on 12/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGFoodListViewController.h"
#import "LZDataAccess.h"
#import "LZUtility.h"
#import "LZFoodTypeButton.h"
#import "NGSingleFoodViewController.h"
#define FoodItemMargin 15
@interface NGFoodListViewController ()
{
    float backViewContentHeight;
    BOOL isFirstLoad;
    BOOL isChinese;
}

@end

@implementation NGFoodListViewController
@synthesize foodArray;
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
    int foodCount = [foodArray count];
    int totalFloor = foodCount/3+ ((foodCount%3 == 0)?0:1);
    backViewContentHeight = totalFloor*(80+FoodItemMargin)+FoodItemMargin;
    isFirstLoad = YES;
    isChinese = [LZUtility isCurrentLanguageChinese];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.mainScrollView setContentSize:CGSizeMake(320, backViewContentHeight+30)];
    [self.backView setFrame:CGRectMake(10, 15, 300, backViewContentHeight)];
    [self.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.backView.layer setBorderWidth:0.5f];
    if (isFirstLoad)
    {
        [self setButtons];
        isFirstLoad = NO;
    }
}
-(void)setButtons
{
    float startY = 15;
    int floor = 1;
    int perRowCount = 3;
    float startX;
    for (int i=0; i< [self.foodArray count]; i++)
    {
        
        if (i>=floor *perRowCount)
        {
            floor+=1;
        }
        startX = 15+(i-(floor-1)*perRowCount)*95;
        NSDictionary *aFood = [self.foodArray  objectAtIndex:i];
        //NSLog(@"picture path food list %@",aFood);
        NSString *picturePath;
        NSString *picPath = [aFood objectForKey:@"PicPath"];
        if (picPath == nil || [picPath isEqualToString:@""])
        {
            picturePath = [[NSBundle mainBundle]pathForResource:@"defaulFoodPic" ofType:@"png"];
        }
        else
        {
            NSString * picFolderPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"foodDealed"];
            picturePath = [picFolderPath stringByAppendingPathComponent:picPath];
        }
        UIImage *foodImage = [UIImage imageWithContentsOfFile:picturePath];
        NSString *foodQueryKey;
        if (isChinese)
        {
            foodQueryKey = @"CnCaption";
        }
        else
        {
            foodQueryKey = @"FoodNameEn";
        }
        NSString *foodName = [aFood objectForKey:foodQueryKey];

        LZFoodTypeButton *foodButton = [[LZFoodTypeButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*95, 80, 80)];
        [self.backView addSubview:foodButton];
        [foodButton setBackgroundImage:foodImage forState:UIControlStateNormal];
        foodButton.tag = i+100;
        [foodButton addTarget:self action:@selector(foodButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [foodButton.typeLabel setText:foodName];
    }

}
-(void)foodButtonTapped:(LZFoodTypeButton*)foodButton
{
    int tag = foodButton.tag -100;
    NSDictionary *foodAtr = [self.foodArray  objectAtIndex:tag];
    NSString *foodQueryKey;
    if (isChinese)
    {
        foodQueryKey = @"CnCaption";
    }
    else
    {
        foodQueryKey = @"FoodNameEn";
    }
    NSString *foodName = [foodAtr objectForKey:foodQueryKey];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    NGSingleFoodViewController *singleFoodViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGSingleFoodViewController"];
    singleFoodViewController.title = foodName;
    singleFoodViewController.foodInfoDict = foodAtr;
    [self.navigationController pushViewController:singleFoodViewController animated:YES];
    //NSLog(@"%@",foodAtr);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
