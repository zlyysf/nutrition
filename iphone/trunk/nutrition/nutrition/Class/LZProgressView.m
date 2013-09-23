//
//  LZProgressView.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZProgressView.h"

@implementation LZProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    if (needDisplay)
    {
        CGContextRef     context = UIGraphicsGetCurrentContext();
        [self drawWithShadows:context];
        

    }
}
-(void) drawWithShadows :(CGContextRef) myContext
{
    CGSize          myShadowOffset = CGSizeMake (0,  0.5);
    float           myColorValues[] = {140/255.f, 137/255.f, 137/255.f, 0.75};
    CGColorRef      myColor;
    CGColorSpaceRef myColorSpace;
    CGContextSaveGState(myContext);
//    CGContextSetShadow (myContext, myShadowOffset, 0);
    
    // Your drawing code here
    myColorSpace = CGColorSpaceCreateDeviceRGB ();
    myColor = CGColorCreate (myColorSpace, myColorValues);
    CGContextSetShadowWithColor (myContext, myShadowOffset, 0.5, myColor);
    // Your drawing code here
    [[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1] setStroke];//设置线条颜色
    [drawingBackColor setFill]; //设置填充颜色
    //画圆角矩形
    [self drawRectangle:drawingRect withRadius:drawingBackRadius ];
    


    CGColorRelease (myColor);
    CGColorSpaceRelease (myColorSpace);
    CGContextRestoreGState(myContext);
    if (drawingProgress <0.01f)
    {
        return;
    }
    CGRect fillRect = CGRectMake(drawingRect.origin.x+3, drawingRect.origin.y+3, (drawingRect.size.width-6)*drawingProgress, drawingRect.size.height-6);

    [drawingFillColor setStroke];
    [drawingFillColor setFill];
    [self drawRectangle:fillRect withRadius:drawingFillRadius];

}
- (void)drawProgressForRect:(CGRect)rect backgroundColor:(UIColor*)backColor fillColor:(UIColor*)fillColor progress:(float)progress withBackRadius:(float)backRadius fillRadius:(float)fillRadius;
{
    needDisplay = YES;
    drawingRect = rect;
    drawingBackColor = backColor;
    drawingFillColor = fillColor;
    drawingProgress = progress;
    drawingBackRadius = backRadius;
    drawingFillRadius = fillRadius;
    [self setNeedsDisplay];
    //[self setNeedsLayout];
    
}
//- (void)layoutSubviews
//{
//    
//}
-(void)drawRectangle:(CGRect)rect withRadius:(float)radius
{
    CGContextRef     context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef pathRef = [self pathwithFrame:rect withRadius:radius];
    
    CGContextAddPath(context, pathRef);
    CGContextSetLineWidth(context, 0.5);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    CGPathRelease(pathRef);
}
-(CGMutablePathRef)pathwithFrame:(CGRect)frame withRadius:(float)radius
{
    CGPoint x1,x2,x3,x4; //x为4个顶点
    CGPoint y1,y2,y3,y4,y5,y6,y7,y8; //y为4个控制点
    //从左上角顶点开始，顺时针旋转,x1->y1->y2->x2
    
    x1 = frame.origin;
    x2 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y);
    x3 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height);
    x4 = CGPointMake(frame.origin.x                 , frame.origin.y+frame.size.height);
    
    
    y1 = CGPointMake(frame.origin.x+radius, frame.origin.y);
    y2 = CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y);
    y3 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+radius);
    y4 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height-radius);
    
    y5 = CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y+frame.size.height);
    y6 = CGPointMake(frame.origin.x+radius, frame.origin.y+frame.size.height);
    y7 = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height-radius);
    y8 = CGPointMake(frame.origin.x, frame.origin.y+radius);
    
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    if (radius<=0) {
        CGPathMoveToPoint(pathRef,    &CGAffineTransformIdentity, x1.x,x1.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x2.x,x2.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x3.x,x3.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x4.x,x4.y);
    }else
    {
        CGPathMoveToPoint(pathRef,    &CGAffineTransformIdentity, y1.x,y1.y);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y2.x,y2.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x2.x,x2.y,y3.x,y3.y,radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y4.x,y4.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x3.x,x3.y,y5.x,y5.y,radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y6.x,y6.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x4.x,x4.y,y7.x,y7.y,radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y8.x,y8.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x1.x,x1.y,y1.x,y1.y,radius);
        
    }
    
    
    CGPathCloseSubpath(pathRef);
    
    //[[UIColor whiteColor] setFill];
    //[[UIColor blackColor] setStroke];
    
    return pathRef;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
