//
//  NGChartViewController.h
//  nutrition
//
//  Created by liu miao on 12/11/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGCycleScrollView.h"
#import "LZScatterViewController.h"
@interface NGChartViewController : UIViewController<NGCycleScrollViewDatasource,NGCycleScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *contentTypeChangeControl;
@property (nonatomic,strong)LZScatterViewController *chart1Controller;
@property (nonatomic,strong)LZScatterViewController *chart2Controller;
@property (nonatomic,strong)LZScatterViewController *chart3Controller;
@end
