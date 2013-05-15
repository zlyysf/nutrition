//
//  LZSecretSettingViewController.m
//  nutrition
//
//  Created by Yasofon on 13-5-15.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZSecretSettingViewController.h"
#import "LZConstants.h"

@interface LZSecretSettingViewController ()

@end

@implementation LZSecretSettingViewController

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
	// Do any additional setup after loading the view.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( [userDefaults objectForKey:LZSettingKey_randomSelectFood]!=nil ){
        [self.switchRandomSelectFood setOn: [userDefaults boolForKey:LZSettingKey_randomSelectFood]];
    }
    
    if ( [userDefaults objectForKey:LZSettingKey_randomRangeSelectFood]!=nil ){
        self.textfieldRandomRangeSelectFood.text = [userDefaults stringForKey:LZSettingKey_randomRangeSelectFood];
    }
    
    
    if ( [userDefaults objectForKey:LZSettingKey_needLimitNutrients]!=nil ){
        [self.switchNeedLimitNutrients setOn: [userDefaults boolForKey:LZSettingKey_needLimitNutrients]];
    }
    
    if ( [userDefaults objectForKey:LZSettingKey_limitRecommendFoodCount]!=nil ){
        self.textfieldLimitRecommendFoodCount.text = [userDefaults stringForKey:LZSettingKey_limitRecommendFoodCount];
    }
    
    if ( [userDefaults objectForKey:LZSettingKey_notAllowSameFood]!=nil ){
        [self.switchNotAllowSameFood setOn: [userDefaults boolForKey:LZSettingKey_notAllowSameFood]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSaveClick:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *val;
    val = [NSNumber numberWithBool: self.switchRandomSelectFood.isOn];
    [userDefaults setValue:val forKey:LZSettingKey_randomSelectFood];
    
    val = [NSNumber numberWithInt: [self.textfieldRandomRangeSelectFood.text intValue]];
    [userDefaults setValue:val forKey:LZSettingKey_randomRangeSelectFood];
    
    val = [NSNumber numberWithBool: self.switchNeedLimitNutrients.isOn];
    [userDefaults setValue:val forKey:LZSettingKey_needLimitNutrients];
    
    val = [NSNumber numberWithInt: [self.textfieldLimitRecommendFoodCount.text intValue]];
    [userDefaults setValue:val forKey:LZSettingKey_limitRecommendFoodCount];
    
    val = [NSNumber numberWithBool: self.switchNotAllowSameFood.isOn];
    [userDefaults setValue:val forKey:LZSettingKey_notAllowSameFood];

    
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
