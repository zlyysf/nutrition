//
//  LZNutrientQueryMainNavController.m
//  nutrition
//
//  Created by Yasofon on 14-6-6.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import "LZNutrientQueryMainNavController.h"

#import "NGFoodCombinationListViewController.h"

@interface LZNutrientQueryMainNavController ()

@end

@implementation LZNutrientQueryMainNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *storyboardModFCL = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
        
        NGFoodCombinationListViewController *controllFcl = [storyboardModFCL instantiateViewControllerWithIdentifier:@"NGFoodCombinationListViewController"];
        self = [self initWithRootViewController:controllFcl];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [self pushViewController:controllFcl animated:NO];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
