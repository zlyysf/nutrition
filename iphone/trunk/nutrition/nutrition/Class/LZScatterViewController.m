////
//  LZScatterViewController.m
//  health
//
//  Created by Chenglei Shen on 11/25/13.
//  Copyright (c) 2013 Dalei Li. All rights reserved.
//

#import "LZScatterViewController.h"

#define BLUE_PLOT_IDENTIFIER @"blue plot"
#define GREEN_PLOT_IDENTIFIER @"green plot"

@interface LZScatterViewController ()

//@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTXYGraph *graph;

@end

@implementation LZScatterViewController

- (id)init
{
    self = [super init];
    return self;
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if (self.scatterType == ScatterTypeBP) {
        if ([plot.identifier isEqual:BLUE_PLOT_IDENTIFIER]) {
            return [self.dataForPlot[1] count]; //Hight Blood Pressure
        }
        else
            return [self.dataForPlot[0] count]; //Low Blood Pressure
    }
    else
        return [self.dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSArray *dataSource;
    if (self.scatterType == ScatterTypeBP) {
        if ([plot.identifier isEqual:BLUE_PLOT_IDENTIFIER]) {
            dataSource = self.dataForPlot[1]; //Hight Blood Pressure
        }
        else
            dataSource = self.dataForPlot[0]; //Low Blood Pressure
    }
    else
        dataSource = self.dataForPlot;
    NSString * key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber * num = dataSource[index][key];
    return num;
}

#pragma mark -
#pragma mark Configure Plot

- (void)configureScatterView:(CGRect)frame
{
    self.view.frame = frame;
    [self configureHost];
    [self configureGraph];
    [self configurePlotSpace];
    [self configureAxis];
    [self configurePlot];
}

- (void)configureHost
{
    CGRect bound = self.view.bounds;
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:bound];
    [self.view addSubview:self.hostView];
}

- (void)configureGraph
{
    self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    self.graph.paddingLeft = self.graph.paddingRight = 0.0;
    self.graph.paddingTop = self.graph.paddingBottom = 0.0;
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [self.graph applyTheme:theme];
    
    // Remove the border line of the graph
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineWidth = 0;
    lineStyle.lineColor = [CPTColor clearColor];
    self.graph.plotAreaFrame.borderLineStyle = lineStyle;
    //self.graph.fill = nil;
    //self.graph.plotAreaFrame.fill = nil;
    self.hostView.hostedGraph = self.graph;
}

- (void)configurePlotSpace
{
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    if (self.scatterType == ScatterTypeBMI) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-3.5) length:CPTDecimalFromFloat(34.5)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(20.75) length:CPTDecimalFromFloat(2.5)];
    }
    else if (self.scatterType == ScatterTypeTemperature) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-3.5) length:CPTDecimalFromFloat(34.5)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(34.1) length:CPTDecimalFromFloat(8.2)];
    }
    else if (self.scatterType == ScatterTypeBP) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-3) length:CPTDecimalFromFloat(34)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(45) length:CPTDecimalFromFloat(157)];
    }
    else {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2.5) length:CPTDecimalFromFloat(33.5)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-12) length:CPTDecimalFromFloat(114)];
    }
}

- (void)configureAxis
{
    [self configureAxisX];
    [self configureAxisY];
}

- (void)configureAxisX
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
//    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
//    lineStyle.miterLimit = 1.0f;
//    lineStyle.lineWidth = 2.0;
//    lineStyle.lineColor = [CPTColor blackColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    if (self.scatterType == ScatterTypeBMI) {
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"21"); // Y coordinate of Axis X
    }
    else if (self.scatterType == ScatterTypeTemperature)
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"35");
    else if (self.scatterType == ScatterTypeBP)
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"60");
    else
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    
    x.majorIntervalLength = CPTDecimalFromString(@"4");   // Major tick interval
    x.minorTicksPerInterval = 1;    // Count of minor ticks between 2 major ticks
    x.minorTickLineStyle = x.majorTickLineStyle;
    NSNumberFormatter *xFormatter = [[NSNumberFormatter alloc] init];
    
    [xFormatter setMaximumFractionDigits:1];
    
    x.labelFormatter = xFormatter;
    
    
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    x.title = @"Day of Month";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 25.0f;
    
    //    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    //    axisLineStyle.lineWidth = 1.0f;
    //    axisLineStyle.lineColor = [CPTColor blackColor];
    //    x.axisLineStyle = axisLineStyle;
    
    //x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    //    axisTextStyle.color = [CPTColor blackColor];
    //    axisTextStyle.fontName = @"Helvetica-Bold";
    //    axisTextStyle.fontSize = 11.0f;
    //    x.labelTextStyle = axisTextStyle;
    
    //x.majorTickLineStyle = axisLineStyle;
    //    x.majorTickLength = 4.0f;
    
    //    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    //    tickLineStyle.lineColor = [CPTColor blackColor];
    //    tickLineStyle.lineWidth = 20.0f;
    //    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    //    tickLineStyle.lineColor = [CPTColor blackColor];
    //    tickLineStyle.lineWidth = 1.0f;
    
    x.tickDirection = CPTSignNegative;
    
    
    //    CGFloat dateCount = [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
    //    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    //    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    //    NSInteger i = 0;
    //    for (NSString *date in [[CPDStockPriceStore sharedInstance] datesInMonth]) {
    //        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date  textStyle:x.labelTextStyle];
    //        CGFloat location = i++;
    //        label.tickLocation = CPTDecimalFromCGFloat(location);
    //        label.offset = x.majorTickLength;
    //        if (label) {
    //            [xLabels addObject:label];
    //            [xLocations addObject:[NSNumber numberWithFloat:location]];
    //        }
    //    }
    //    x.axisLabels = xLabels;
    //    x.majorTickLocations = xLocations;
    
    
    // 需要排除的不显示数字的主刻度
    NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-5) length:CPTDecimalFromFloat(4)],
                                 [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(31.5) length:CPTDecimalFromFloat(4)]];
    x.labelExclusionRanges = exclusionRanges;
}

- (void)configureAxisY
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis * y = axisSet.yAxis;
    
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    if (self.scatterType == ScatterTypeTemperature) {
        y.title = @"(℃)";
        y.titleTextStyle = axisTitleStyle;
        y.titleOffset = 15;
        y.majorGridLineStyle = y.majorTickLineStyle;
        y.labelOffset = -8.0f;
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        //[yFormatter setMinimumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"1");   // Major tick interval
        y.minorTicksPerInterval = 1;    // Count of minor ticks between 2 major ticks
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(33) length:CPTDecimalFromFloat(1.5)]];
        y.labelExclusionRanges = exclusionRanges;

    }
    else if (self.scatterType == ScatterTypeBMI) {
        y.title = nil;
        y.titleTextStyle = axisTitleStyle;
        y.titleOffset = 10;
        y.majorGridLineStyle = y.majorTickLineStyle;
        y.labelOffset = -8.0f;
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        [yFormatter setMinimumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"0.2");   // Major tick interval
        y.minorTicksPerInterval = 1;    // Count of minor ticks between 2 major ticks
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(20.9)]];
        y.labelExclusionRanges = exclusionRanges;
        
    }
    else if (self.scatterType == ScatterTypeBP) {
        y.title = nil;
        y.titleTextStyle = axisTitleStyle;
        y.titleOffset = 10;
        y.majorGridLineStyle = y.majorTickLineStyle;
        y.labelOffset = -8.0f;
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"20");   // Major tick interval
        y.minorTicksPerInterval = 2;    // Count of minor ticks between 2 major ticks
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(40) length:CPTDecimalFromFloat(19)]];
        y.labelExclusionRanges = exclusionRanges;
        
    }
    else {
        y.title = nil;
        y.titleTextStyle = axisTitleStyle;
        y.titleOffset = 10;
        y.majorGridLineStyle = y.majorTickLineStyle;
        y.labelOffset = -8.0f;
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"20");   // Major tick interval
        y.minorTicksPerInterval = 2;    // Count of minor ticks between 2 major ticks
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-20) length:CPTDecimalFromFloat(21)]];
        y.labelExclusionRanges = exclusionRanges;
    }
   
    y.minorTickLineStyle = y.majorTickLineStyle;
    
    
    y.tickDirection = CPTSignNegative;
}

- (void)configurePlot
{
    CPTScatterPlot *bluePlot = (CPTScatterPlot *)[self.graph plotWithIdentifier:BLUE_PLOT_IDENTIFIER];
    if (bluePlot == nil) {
        bluePlot  = [[CPTScatterPlot alloc] init];
        [self.graph addPlot:bluePlot];
        CPTMutableLineStyle *blueLineStyle  = [[CPTMutableLineStyle alloc] init];
        blueLineStyle.miterLimit            = 1.0f;
        blueLineStyle.lineWidth             = 3.0f;
        blueLineStyle.lineColor             = [CPTColor blueColor];
        
        
        bluePlot.dataLineStyle     = blueLineStyle;
        bluePlot.identifier        = BLUE_PLOT_IDENTIFIER;
        bluePlot.dataSource        = self;
        
        CPTMutableLineStyle *blueSymbolLineStyle = [CPTMutableLineStyle lineStyle];
        blueSymbolLineStyle.lineColor             = [CPTColor blackColor];
        blueSymbolLineStyle.lineWidth             = 2.0;
        
        CPTPlotSymbol *bluePlotSymbol  = [CPTPlotSymbol ellipsePlotSymbol];
        bluePlotSymbol.fill            = [CPTFill fillWithColor:[CPTColor blueColor]];
        bluePlotSymbol.lineStyle       = blueSymbolLineStyle;
        bluePlotSymbol.size            = CGSizeMake(10.0, 10.0);
        bluePlot.plotSymbol = bluePlotSymbol;
    }
    
   
    
    CPTScatterPlot *greenPlot = (CPTScatterPlot *)[self.graph plotWithIdentifier:GREEN_PLOT_IDENTIFIER];
    if (self.scatterType == ScatterTypeBP) {
        if (greenPlot == nil) {
            greenPlot  = [[CPTScatterPlot alloc] init];
            [self.graph addPlot:greenPlot];
            CPTMutableLineStyle *greenLineStyle  = [[CPTMutableLineStyle alloc] init];
            greenLineStyle.miterLimit            = 1.0f;
            greenLineStyle.lineWidth             = 3.0f;
            greenLineStyle.lineColor             = [CPTColor greenColor];
            
            
            greenPlot.dataLineStyle     = greenLineStyle;
            greenPlot.identifier        = GREEN_PLOT_IDENTIFIER;
            greenPlot.dataSource        = self;
            
            CPTMutableLineStyle *greenSymbolLineStyle = [CPTMutableLineStyle lineStyle];
            greenSymbolLineStyle.lineColor             = [CPTColor blackColor];
            greenSymbolLineStyle.lineWidth             = 2.0;
            
            CPTPlotSymbol *greenPlotSymbol  = [CPTPlotSymbol ellipsePlotSymbol];
            greenPlotSymbol.fill            = [CPTFill fillWithColor:[CPTColor greenColor]];
            greenPlotSymbol.lineStyle       = greenSymbolLineStyle;
            greenPlotSymbol.size            = CGSizeMake(10.0, 10.0);
            greenPlot.plotSymbol = greenPlotSymbol;
        }
    }
    else {
        if(greenPlot != nil) {
            [self.graph removePlot:greenPlot];
        }
    }
    
}

#pragma mark -
#pragma mark reloadData
- (void)reloadData
{
    [self configureAxis];
    [self configurePlotSpace];
    [self configurePlot];
    [self.graph reloadData];
}

@end
