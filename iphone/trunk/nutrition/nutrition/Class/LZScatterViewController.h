//
//  LZScatterViewController.h
//  health
//
//  Created by Chenglei Shen on 11/25/13.
//  Copyright (c) 2013 Dalei Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

typedef  NS_ENUM(NSUInteger, ScatterType) {
    ScatterTypeNI = 0, // Nutrient Index
    ScatterTypeBMI = 1, // Body Mass Index
    ScatterTypeWeight = 2,
    ScatterTypeTemperature = 3,
    ScatterTypeBP = 4, // Blood Pressure
    ScatterTypeHeartbeat = 5,
};

#define POINTS_COUNT 10

@interface LZScatterViewController : UIViewController <CPTPlotDataSource>

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, assign) ScatterType scatterType;
@property (nonatomic, strong) NSArray *dataForPlot;

- (void)configureScatterView:(CGRect)frame;
- (void)reloadData;
@end
