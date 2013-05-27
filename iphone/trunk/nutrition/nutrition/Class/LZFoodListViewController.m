//
//  LZFoodListViewController.m
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodListViewController.h"
#import "LZDailyIntakeViewController.h"
@interface LZFoodListViewController ()

@end

@implementation LZFoodListViewController

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
    self.title = @"食物";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFoodAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZDailyIntakeViewController *dailyIntakeController = [storyboard instantiateViewControllerWithIdentifier:@"LZDailyIntakeViewController"];
    UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                          sharedApplication].keyWindow.rootViewController;

    //UINavigationController* mainNavController = (UINavigationController*)storyboard.instantiateInitialViewController;
    //NSLog(@"%@",[mainNavController description]);
    //NSLog(@"%@",[initialController description]);
    [initialController pushViewController:dailyIntakeController animated:YES];
    
}

@end
