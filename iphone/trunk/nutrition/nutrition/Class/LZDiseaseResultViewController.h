//
//  LZDiseaseResultViewController.h
//  nutrition
//
//  Created by liu miao on 8/28/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDiseaseResultViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *diseaseInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *nutrientLabel;
@property (strong, nonatomic) IBOutlet UIButton *recommendFoodButton;
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UIView *resultView;
@property (strong,nonatomic)NSArray *relatedNutritionArray;
@end
