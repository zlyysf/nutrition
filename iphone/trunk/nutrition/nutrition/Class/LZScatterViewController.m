////
//  LZScatterViewController.m
//  health
//
//  Created by Chenglei Shen on 11/25/13.
//  Copyright (c) 2013 Dalei Li. All rights reserved.
//

#import "LZScatterViewController.h"

#define BLUE_PLOT_IDENTIFIER @"BluePlot"
#define GREEN_PLOT_IDENTIFIER @"GreenPlot"

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
    self.graph.paddingTop = self.graph.paddingBottom = 8.0;
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
    //plotSpace.allowsUserInteraction = YES;
    if (self.scatterType == ScatterTypeNI) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2.0) length:CPTDecimalFromFloat(33.7)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(57.5) length:CPTDecimalFromFloat(43.5)];
    }
    else if (self.scatterType == ScatterTypeBMI) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2.5) length:CPTDecimalFromFloat(34.2)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(20.86) length:CPTDecimalFromFloat(2.39)];
    }
    else if (self.scatterType == ScatterTypeWeight) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.4) length:CPTDecimalFromFloat(33.1)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(36.5) length:CPTDecimalFromFloat(60)];
    }
    else if (self.scatterType == ScatterTypeTemperature) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.4) length:CPTDecimalFromFloat(33.1)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(34.5) length:CPTDecimalFromFloat(7.8)];
    }
    else if (self.scatterType == ScatterTypeBP) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2.0) length:CPTDecimalFromFloat(33.7)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(50) length:CPTDecimalFromFloat(152)];
    }
    else if (self.scatterType == ScatterTypeHeartbeat) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.4) length:CPTDecimalFromFloat(33.1)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(43) length:CPTDecimalFromFloat(28)];
    }
    else {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2.5) length:CPTDecimalFromFloat(33.5)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-8) length:CPTDecimalFromFloat(110)];
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
    CPTXYAxis * x = axisSet.xAxis;
    
    // Config the axis label text style
    CPTMutableTextStyle *axisLabelTextStyle = [x.labelTextStyle mutableCopy];
    axisLabelTextStyle.color = [CPTColor grayColor];
    axisLabelTextStyle.fontName = @"Helvetica-Bold";
    axisLabelTextStyle.fontSize = 12.0f;
    x.labelTextStyle = axisLabelTextStyle;
    
    // Config the line style of Axis X major tick
    CPTMutableLineStyle *lineStyle = [x.axisLineStyle mutableCopy];
    //lineStyle.lineWidth = 0.5;
    x.majorTickLineStyle = lineStyle;
    //x.axisLineStyle = lineStyle;
    
    //x.visibleAxisRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1) length:CPTDecimalFromFloat(33.5)];
    if (self.scatterType == ScatterTypeNI)
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"60");
    else if (self.scatterType == ScatterTypeBMI) {
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"21"); // Y coordinate of Axis X
    }
    else if (self.scatterType == ScatterTypeWeight)
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"40");
    else if (self.scatterType == ScatterTypeTemperature)
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"35");
    else if (self.scatterType == ScatterTypeBP)
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"60");
    else if (self.scatterType == ScatterTypeHeartbeat)
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"45");
    else
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    

    // Axis X is using the customized lables and ticks, so these configuration is not used for now
    //x.majorIntervalLength = CPTDecimalFromString(@"4");   // Major tick interval
    //x.minorTicksPerInterval = 1;    // Count of minor ticks between 2 major ticks
    //x.minorTickLineStyle = x.majorTickLineStyle;
    //NSNumberFormatter *xFormatter = [[NSNumberFormatter alloc] init];
    //[xFormatter setMaximumFractionDigits:1];
    //x.labelFormatter = xFormatter;
    
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.tickDirection = CPTSignNegative;
    x.majorTickLength = 4.0f;
    
    // Customize the labels and ticks of Axis X
    NSUInteger dateCount = 11;
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    for (int i = 0; i < dateCount; i++) {
        int dateNum = i * 3 + 1;
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d", dateNum]  textStyle:x.labelTextStyle];
        label.tickLocation = CPTDecimalFromCGFloat(dateNum);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:dateNum]];
//            if (dateNum != 1) {
//                [xLocations addObject:[NSNumber numberWithFloat:dateNum]];
//            }
            
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    //x.minorTickAxisLabels = xLabels;
    //x.minorTickLocations = xLocations;
    
    
    //x.axisConstraints = [CPTConstraints constraintWithUpperOffset:132];
    
    NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-5) length:CPTDecimalFromFloat(4)],
                                 [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(31.5) length:CPTDecimalFromFloat(4)]];
    x.labelExclusionRanges = exclusionRanges;
    x.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1) length:CPTDecimalFromFloat(30.1)];
}

- (void)configureAxisY
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *y = axisSet.yAxis;
    
    // Config the axis title text style. Not used for now
    //CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    //axisTitleStyle.color = [CPTColor blackColor];
    //axisTitleStyle.fontName = @"Helvetica-Bold";
    //axisTitleStyle.fontSize = 12.0f;
    
    // Config the axis label text style
    CPTMutableTextStyle *axisLabelTextStyle = [y.labelTextStyle mutableCopy];
    axisLabelTextStyle.color = [CPTColor grayColor];
    axisLabelTextStyle.fontName = @"Helvetica-Bold";
    axisLabelTextStyle.fontSize = 12.0f;
    y.labelTextStyle = axisLabelTextStyle;
    
    // Config the line style of Axis Y, major grid line and the major tick
    CPTMutableLineStyle *lineStyle = [y.axisLineStyle mutableCopy];
    lineStyle.lineWidth = 0.5;
    y.majorGridLineStyle = lineStyle;
    //y.axisLineStyle = lineStyle;
    y.majorTickLineStyle = lineStyle;
    
    y.tickDirection = CPTSignNegative;
    y.labelOffset = 2.0f;
    y.majorTickLength = 0.0f;
    y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1) length:CPTDecimalFromFloat(30.1)];
    y.minorTicksPerInterval = 0; // Count of minor ticks between 2 major ticks
    
    //y.minorTickLineStyle = y.majorTickLineStyle;
    
    if (self.scatterType == ScatterTypeNI) {
        
        // Config the title of axis Y. Not used for now
        //y.title = nil;
        //y.titleTextStyle = axisTitleStyle;
        //y.titleOffset = 10;
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"5");   // Major tick interval
        //y.minorTicksPerInterval = 0;    // Count of minor ticks between 2 major ticks
        
        y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(60) length:CPTDecimalFromFloat(40.5)];
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(40) length:CPTDecimalFromFloat(19)]];
        y.labelExclusionRanges = exclusionRanges;
        
    }
    else if (self.scatterType == ScatterTypeBMI) {
        y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(21) length:CPTDecimalFromFloat(5)];
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        [yFormatter setMinimumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"0.2");   // Major tick interval
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(20.9)]];
        y.labelExclusionRanges = exclusionRanges;
        
    }
    else if (self.scatterType == ScatterTypeWeight) {
        y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(40) length:CPTDecimalFromFloat(56.5)];
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"5");   // Major tick interval
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(30) length:CPTDecimalFromFloat(9)]];
        y.labelExclusionRanges = exclusionRanges;
        
    }
    else if (self.scatterType == ScatterTypeTemperature) {
        y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(35) length:CPTDecimalFromFloat(7.3)];
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        //[yFormatter setMinimumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"1");   // Major tick interval
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(33) length:CPTDecimalFromFloat(1.5)]];
        y.labelExclusionRanges = exclusionRanges;

    }
    else if (self.scatterType == ScatterTypeBP) {
        y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(60) length:CPTDecimalFromFloat(142)];
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"20");   // Major tick interval
        //y.minorTicksPerInterval = 2;    // Count of minor ticks between 2 major ticks
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(40) length:CPTDecimalFromFloat(19)]];
        y.labelExclusionRanges = exclusionRanges;
        
    }
    else if (self.scatterType == ScatterTypeHeartbeat) {
        y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(45) length:CPTDecimalFromFloat(26)];
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"5");   // Major tick interval
        //y.minorTicksPerInterval = 1;    // Count of minor ticks between 2 major ticks
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(30) length:CPTDecimalFromFloat(11)]];
        y.labelExclusionRanges = exclusionRanges;
        
    }
    else {
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"20");   // Major tick interval
        //y.minorTicksPerInterval = 2;    // Count of minor ticks between 2 major ticks
        
        NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-20) length:CPTDecimalFromFloat(21)]];
        y.labelExclusionRanges = exclusionRanges;
    }
    
}

- (void)configurePlot
{
    CPTScatterPlot *bluePlot = (CPTScatterPlot *)[self.graph plotWithIdentifier:BLUE_PLOT_IDENTIFIER];
    if (bluePlot == nil) {
        bluePlot  = [[CPTScatterPlot alloc] init];
        [self.graph addPlot:bluePlot];
        CPTMutableLineStyle *blueLineStyle  = [[CPTMutableLineStyle alloc] init];
        blueLineStyle.miterLimit            = 1.0f;
        blueLineStyle.lineWidth             = 1.5f;
        blueLineStyle.lineColor             = [CPTColor blueColor];
        
        
        bluePlot.dataLineStyle     = blueLineStyle;
        bluePlot.identifier        = BLUE_PLOT_IDENTIFIER;
        bluePlot.dataSource        = self;
        
        CPTMutableLineStyle *blueSymbolLineStyle = [CPTMutableLineStyle lineStyle];
        blueSymbolLineStyle.lineColor             = [CPTColor blueColor];
        blueSymbolLineStyle.lineWidth             = 0.0f;
        
        CPTPlotSymbol *bluePlotSymbol  = [CPTPlotSymbol ellipsePlotSymbol];
        bluePlotSymbol.fill            = [CPTFill fillWithColor:[CPTColor blueColor]];
        bluePlotSymbol.lineStyle       = blueSymbolLineStyle;
        bluePlotSymbol.size            = CGSizeMake(5.0, 5.0);
        bluePlot.plotSymbol = bluePlotSymbol;
    }
    
   
    // Only the Blood Pressure tab is using the green plot as the low blood pressure plot
    
    CPTScatterPlot *greenPlot = (CPTScatterPlot *)[self.graph plotWithIdentifier:GREEN_PLOT_IDENTIFIER];
    if (self.scatterType == ScatterTypeBP) {
        if (greenPlot == nil) {
            greenPlot  = [[CPTScatterPlot alloc] init];
            [self.graph addPlot:greenPlot];
            CPTMutableLineStyle *greenLineStyle  = [[CPTMutableLineStyle alloc] init];
            greenLineStyle.miterLimit            = 1.0f;
            greenLineStyle.lineWidth             = 1.5f;
            greenLineStyle.lineColor             = [CPTColor greenColor];
            
            
            greenPlot.dataLineStyle     = greenLineStyle;
            greenPlot.identifier        = GREEN_PLOT_IDENTIFIER;
            greenPlot.dataSource        = self;
            
            CPTMutableLineStyle *greenSymbolLineStyle = [CPTMutableLineStyle lineStyle];
            greenSymbolLineStyle.lineColor             = [CPTColor greenColor];
            greenSymbolLineStyle.lineWidth             = 0.0f;
            
            CPTPlotSymbol *greenPlotSymbol  = [CPTPlotSymbol ellipsePlotSymbol];
            greenPlotSymbol.fill            = [CPTFill fillWithColor:[CPTColor greenColor]];
            greenPlotSymbol.lineStyle       = greenSymbolLineStyle;
            greenPlotSymbol.size            = CGSizeMake(5.0, 5.0);
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
