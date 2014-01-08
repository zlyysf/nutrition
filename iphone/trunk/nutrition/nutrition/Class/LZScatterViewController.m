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

const float TickIntervalNI = 5.0;
const float TickIntervalBMI = 0.5;
const float TickIntervalWeight = 5.0;
const float TickIntervalTemperature = 1.0;
const float TickIntervalBP = 20.0;
const float TickIntervalHeartbeat = 5.0;

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
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2.2) length:CPTDecimalFromFloat(34.2)];
    
    float yPercentUnderX = 0.06;
    float xOrthogonalCoordinate;
    float yMaxTick;
    if (self.scatterType == ScatterTypeNI) {
        CPTPlotRange *yRange = [self yRange];
        xOrthogonalCoordinate = yRange.locationDouble;
        yMaxTick = yRange.locationDouble + yRange.lengthDouble + 1;
    }
    else if (self.scatterType == ScatterTypeBMI) {
        CPTPlotRange *yRange = [self yRange];
        xOrthogonalCoordinate = yRange.locationDouble;
        yMaxTick = yRange.locationDouble + yRange.lengthDouble + 0.1;
    }
    else if (self.scatterType == ScatterTypeWeight) {
        CPTPlotRange *yRange = [self yRange];
        xOrthogonalCoordinate = yRange.locationDouble;
        yMaxTick = yRange.locationDouble + yRange.lengthDouble + 1;
    }
    else if (self.scatterType == ScatterTypeTemperature) {
        CPTPlotRange *yRange = [self yRange];
        xOrthogonalCoordinate = yRange.locationDouble;
        yMaxTick = yRange.locationDouble + yRange.lengthDouble + 0.2;
    }
    else if (self.scatterType == ScatterTypeBP) {
        CPTPlotRange *yRange = [self yRange];
        xOrthogonalCoordinate = yRange.locationDouble;
        yMaxTick = yRange.locationDouble + yRange.lengthDouble + 4;
    }
    else if (self.scatterType == ScatterTypeHeartbeat) {
        CPTPlotRange *yRange = [self yRange];
        xOrthogonalCoordinate = yRange.locationDouble;
        yMaxTick = yRange.locationDouble + yRange.lengthDouble + 1;
    }
    else {
        xOrthogonalCoordinate = 0;
        yMaxTick = 100;
    }
    float yStart = (xOrthogonalCoordinate - yMaxTick * yPercentUnderX) / (1 - yPercentUnderX);
    float yLength = yMaxTick - yStart;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yStart) length:CPTDecimalFromFloat(yLength)];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromFloat(xOrthogonalCoordinate);
    CPTXYAxis *y = axisSet.yAxis;
    y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xOrthogonalCoordinate) length:CPTDecimalFromFloat(yMaxTick - xOrthogonalCoordinate)];
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
    axisLabelTextStyle.color = [CPTColor blackColor];
    axisLabelTextStyle.fontName = @"Helvetica Neue";
    axisLabelTextStyle.fontSize = 12.0f;
    x.labelTextStyle = axisLabelTextStyle;
    
    // Config the line style of Axis X major tick
    CPTMutableLineStyle *lineStyle = [x.axisLineStyle mutableCopy];
    lineStyle.lineWidth = 0.5f;
    lineStyle.lineColor = [CPTColor blackColor];
    x.majorTickLineStyle = lineStyle;
    
    // config axis style
    x.axisLineStyle = lineStyle;
    
    //x.visibleAxisRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1) length:CPTDecimalFromFloat(33.5)];
//    if (self.scatterType == ScatterTypeNI)
//        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"60");
//    else if (self.scatterType == ScatterTypeBMI) {
//        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"21"); // Y coordinate of Axis X
//    }
//    else if (self.scatterType == ScatterTypeWeight)
//        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"40");
//    else if (self.scatterType == ScatterTypeTemperature)
//        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"35");
//    else if (self.scatterType == ScatterTypeBP)
//        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"60");
//    else if (self.scatterType == ScatterTypeHeartbeat)
//        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"45");
//    else
//        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    

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
    axisLabelTextStyle.color = [CPTColor blackColor];
    axisLabelTextStyle.fontName = @"Helvetica Neue";
    axisLabelTextStyle.fontSize = 12.0f;
    y.labelTextStyle = axisLabelTextStyle;
    
    // Config the line style of Axis Y, major grid line and the major tick
    CPTMutableLineStyle *lineStyle = [y.axisLineStyle mutableCopy];
    lineStyle.lineWidth = 0.5f;
    lineStyle.lineColor = [CPTColor lightGrayColor];
    y.majorGridLineStyle = lineStyle;

    // config axis style
    CPTMutableLineStyle *axisLineStyle = [y.axisLineStyle mutableCopy];
    axisLineStyle.lineWidth = 0.5f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    y.axisLineStyle = axisLineStyle;

    
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
        
        y.majorIntervalLength = CPTDecimalFromFloat(TickIntervalNI);   // Major tick interval
        //y.minorTicksPerInterval = 0;    // Count of minor ticks between 2 major ticks
        
        //y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(60) length:CPTDecimalFromFloat(40.5)];
        
        // Config the range where the ticks should not display. Not used for now
        //NSArray *exclusionRanges = @[[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(40) length:CPTDecimalFromFloat(19)]];
        //y.labelExclusionRanges = exclusionRanges;
        
    }
    else if (self.scatterType == ScatterTypeBMI) {
        //y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(21) length:CPTDecimalFromFloat(5)];
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        [yFormatter setMinimumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromFloat(TickIntervalBMI);   // Major tick interval
        
    }
    else if (self.scatterType == ScatterTypeWeight) {
        //y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(45) length:CPTDecimalFromFloat(41.5)];
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromFloat(TickIntervalWeight);   // Major tick interval
        
    }
    else if (self.scatterType == ScatterTypeTemperature) {
        //y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(34) length:CPTDecimalFromFloat(8.3)];
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        //[yFormatter setMinimumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromFloat(TickIntervalTemperature); // Major tick interval
    }
    else if (self.scatterType == ScatterTypeBP) {
        //y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(60) length:CPTDecimalFromFloat(142)];
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromFloat(TickIntervalBP);   // Major tick interval
        //y.minorTicksPerInterval = 2;    // Count of minor ticks between 2 major ticks
    }
    else if (self.scatterType == ScatterTypeHeartbeat) {
        //y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(40) length:CPTDecimalFromFloat(41)];
        
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromFloat(TickIntervalHeartbeat);   // Major tick interval
        //y.minorTicksPerInterval = 1;    // Count of minor ticks between 2 major ticks
        
    }
    else {
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // X coordinate of Axis Y
        
        NSNumberFormatter *yFormatter = [[NSNumberFormatter alloc] init];
        [yFormatter setMaximumFractionDigits:1];
        y.labelFormatter = yFormatter;
        
        y.majorIntervalLength = CPTDecimalFromString(@"20");   // Major tick interval
        //y.minorTicksPerInterval = 2;    // Count of minor ticks between 2 major ticks
    }
    
}

- (void)configurePlot
{
    CPTScatterPlot *bluePlot = (CPTScatterPlot *)[self.graph plotWithIdentifier:BLUE_PLOT_IDENTIFIER];
    if (bluePlot == nil) {
        bluePlot  = [[CPTScatterPlot alloc] init];
        [self.graph addPlot:bluePlot];
        
        // color
        CPTColor *plotColor = [CPTColor colorWithComponentRed:25.0/255.0 green:25.0/255.0 blue:112.0/255.0 alpha:1.0];
        
        CPTMutableLineStyle *blueLineStyle  = [[CPTMutableLineStyle alloc] init];
        blueLineStyle.miterLimit            = 1.0f;
        blueLineStyle.lineWidth             = 1.0f;
        blueLineStyle.lineColor             = plotColor;
        
        
        bluePlot.dataLineStyle     = blueLineStyle;
        bluePlot.identifier        = BLUE_PLOT_IDENTIFIER;
        bluePlot.dataSource        = self;
        
        CPTMutableLineStyle *blueSymbolLineStyle = [CPTMutableLineStyle lineStyle];
        blueSymbolLineStyle.lineColor             = plotColor;
        blueSymbolLineStyle.lineWidth             = 0.5f;
        
        CPTPlotSymbol *bluePlotSymbol  = [CPTPlotSymbol ellipsePlotSymbol];
        bluePlotSymbol.fill            = [CPTFill fillWithColor:plotColor];
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
            
            CPTColor *plotColor = [CPTColor colorWithComponentRed:178.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
            
            
            CPTMutableLineStyle *greenLineStyle  = [[CPTMutableLineStyle alloc] init];
            greenLineStyle.miterLimit            = 1.0f;
            greenLineStyle.lineWidth             = 1.0f;
            greenLineStyle.lineColor             = plotColor;
            
            
            greenPlot.dataLineStyle     = greenLineStyle;
            greenPlot.identifier        = GREEN_PLOT_IDENTIFIER;
            greenPlot.dataSource        = self;
            
            CPTMutableLineStyle *greenSymbolLineStyle = [CPTMutableLineStyle lineStyle];
            greenSymbolLineStyle.lineColor             = plotColor;
            greenSymbolLineStyle.lineWidth             = 0.5f;
            
            CPTPlotSymbol *greenPlotSymbol  = [CPTPlotSymbol ellipsePlotSymbol];
            greenPlotSymbol.fill            = [CPTFill fillWithColor:plotColor];
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

#pragma mark -
#pragma mark Calculate the Y range
- (CPTPlotRange *)yRange
{
    static int gridLineNum = 8;
    float minValue = 0;
    float maxValue = 0;
    int minBPValue = 0;
    int maxBPValue = 0;
    if (self.scatterType == ScatterTypeBP) {
        for (NSArray *bpValues in self.dataForPlot) {
            for (NSDictionary *valuePair in bpValues) {
                int value = [valuePair[@"y"] intValue];
                if (value < minBPValue || minBPValue == 0) {
                    minBPValue = value;
                }
                if (value > maxValue || maxBPValue == 0) {
                    maxBPValue = value;
                }
            }
        }
    }
    else {
        for (NSUInteger i = 0; i < self.dataForPlot.count; i++) {
            float value = [self.dataForPlot[i][@"y"] floatValue];
            if (i == 0) {
                minValue = value;
                maxValue = value;
            }
            else {
                if (value < minValue) {
                    minValue = value;
                }
                if (value > maxValue) {
                    maxValue = value;
                }
            }
        }
    }
    switch (self.scatterType) {
        case ScatterTypeNI:
            if (minValue > 60.0 || self.dataForPlot.count == 0) {
                minValue = 60.0;
            }
            else {
                int quotient = (int)minValue / 10;
                int remainder = (int)minValue % 10;
                if (remainder > TickIntervalNI) {
                    minValue = quotient * 10 + TickIntervalNI;
                }
                else
                    minValue = quotient * 10;
            }
            maxValue = 100.0;
            break;
        case ScatterTypeBMI:
            if (self.dataForPlot.count == 0) {
                minValue = 19.5;
                maxValue = 23.5;
            }
            else {
                if (minValue < 5.0) {
                    minValue = 19.5;
                }
                if (maxValue > 80) {
                    maxValue = 23.5;
                }
                float floorValue = floor(minValue);
                if (minValue - floorValue >= TickIntervalBMI) {
                    floorValue += TickIntervalBMI;
                }
                float ceilValue = ceil(maxValue);
                if (ceilValue - maxValue >= TickIntervalBMI) {
                    ceilValue -= TickIntervalBMI;
                }
                int num = (ceilValue - floorValue) / TickIntervalBMI;
                if (num < gridLineNum) {
                    floorValue -= ((gridLineNum -num) - (gridLineNum - num) / 2) * TickIntervalBMI;
                    ceilValue += ((gridLineNum - num) / 2) * TickIntervalBMI;
                }
                minValue = floorValue;
                maxValue = ceilValue;
            }
            break;
        case ScatterTypeWeight:
            if (self.dataForPlot.count == 0) {
                minValue = 45.0;
                maxValue = 85.0;
            }
            else {
                if (minValue < 20.0) {
                    minValue = 45.0;
                }
                
                if (maxValue > 400) {
                    maxValue = 85.0;
                }
                float floorValue = floor(minValue);
                float ceilValue = ceil(maxValue);
                int quotient = (int)floorValue / 10;
                int remainder = (int)floorValue % 10;
                if (remainder > TickIntervalWeight) {
                    floorValue = quotient * 10 + TickIntervalWeight;
                }
                else
                    floorValue = quotient * 10;
                quotient = (int)ceilValue / 10;
                remainder = (int)ceilValue % 10;
                if (remainder > TickIntervalWeight) {
                    ceilValue = (quotient + 1) * 10;
                }
                else if (remainder == 0)
                    ceilValue = quotient * 10;
                else
                    ceilValue = quotient * 10 + TickIntervalWeight;
                int num = (ceilValue - floorValue) / TickIntervalWeight;
                if (num < gridLineNum) {
                    floorValue -= ((gridLineNum - num) / 2) * TickIntervalWeight;
                    ceilValue += ((gridLineNum - num) - (gridLineNum - num) / 2) * TickIntervalWeight;
                }
                minValue = floorValue;
                maxValue = ceilValue;
            }
            break;
        case ScatterTypeTemperature:
            if (minValue < 30.0 || minValue > 34.0 || self.dataForPlot.count == 0) {
                minValue = 34.0;
            }
            else {
                minValue = floor(minValue);
            }
            maxValue = 42.0;
            break;
        case ScatterTypeBP:
            if (minBPValue == 0 || maxBPValue == 0) {
                minValue = 60.0;
                maxValue = 220.0;
            }
            else {
                if (minBPValue < 30) {
                    minBPValue = 60;
                }
                if (maxBPValue > 280) {
                    maxBPValue = 220;
                }
                int quotient = minBPValue / 10;
                int remainder = quotient % 2;
                if (remainder == 0) {
                    minBPValue = quotient * 10;
                }
                else {
                    minBPValue = (quotient - 1) * 10;
                }
                
                quotient = maxBPValue / (int)TickIntervalBP;
                remainder = maxBPValue % (int)TickIntervalBP;
                if (remainder > 0) {
                    maxBPValue = (quotient + 1) * TickIntervalBP;
                }
                int num = (maxBPValue - minBPValue) / TickIntervalBP;
                if (num < gridLineNum) {
                    minBPValue -= ((gridLineNum - num) / 2) * TickIntervalBP;
                    maxBPValue += ((gridLineNum -num) - (gridLineNum - num) / 2) * TickIntervalBP;
                }
                if (minBPValue <= 0) {
                    minValue = 60.0;
                }
                else
                    minValue = minBPValue;
                maxValue = maxBPValue;
            }
            break;
        case ScatterTypeHeartbeat:
            if (self.dataForPlot.count == 0) {
                minValue = 40.0;
                maxValue = 80.0;
            }
            else {
                if (minValue < 10) {
                    minValue = 40;
                }
                if (maxValue > 150) {
                    maxValue = 80.0;
                }
                float floorValue = floor(minValue);
                float ceilValue = ceil(maxValue);
                int quotient = (int)floorValue / 10;
                int remainder = (int)floorValue % 10;
                if (remainder > TickIntervalHeartbeat) {
                    floorValue = quotient * 10 + TickIntervalHeartbeat;
                }
                else
                    floorValue = quotient * 10;
                quotient = (int)ceilValue / 10;
                remainder = (int)ceilValue % 10;
                if (remainder > TickIntervalHeartbeat) {
                    ceilValue = (quotient + 1) * 10;
                }
                else if (remainder == 0)
                    ceilValue = quotient * 10;
                else
                    ceilValue = quotient * 10 + TickIntervalHeartbeat;
                int num = (ceilValue - floorValue) / TickIntervalHeartbeat;
                if (num < gridLineNum) {
                    floorValue -= ((gridLineNum - num) / 2) * TickIntervalHeartbeat;
                    ceilValue += ((gridLineNum -num) - (gridLineNum - num) / 2) * TickIntervalHeartbeat;
                }
                minValue = floorValue;
                maxValue = ceilValue;
            }
            break;
        default:
            break;
    }
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minValue) length:CPTDecimalFromFloat(maxValue - minValue)];
}

@end
