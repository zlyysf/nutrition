//
//  NGHealthReportViewController.h
//  nutrition
//
//  Created by liu miao on 11/23/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGHealthReportViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) NSArray *lackNutritionArray;
@property (strong, nonatomic) NSArray *potentialArray;
@property (strong, nonatomic) NSArray *attentionArray;
@property (strong, nonatomic) NSArray *recommendFoodArray;
@property (strong, nonatomic) IBOutlet UILabel *BMILabel;
@property (strong, nonatomic) IBOutlet UILabel *BMIScoreLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *BMIProgressBar;
@property (strong, nonatomic) IBOutlet UILabel *BMIDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *nutritionLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *nutritionScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *lackNutritonLabel;
@property (strong, nonatomic) IBOutlet UILabel *recommendFoodLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *recommendFoodScrollView;
@property (strong, nonatomic) IBOutlet UILabel *potentialLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bottomSepLine;
@property (strong, nonatomic) IBOutlet UILabel *attentionLabel;
@end
