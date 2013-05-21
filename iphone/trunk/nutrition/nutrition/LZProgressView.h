//
//  LZProgressView.h
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZProgressView : UIView
{
    UIColor *drawingBackColor;
    UIColor *drawingFillColor;
    float drawingProgress;
    CGRect drawingRect;
    float drawingRadius;
    BOOL needDisplay;
}
@property (nonatomic,strong)UILabel *contentLabel;
- (void)drawProgressForRect:(CGRect)rect backgroundColor:(UIColor*)backColor fillColor:(UIColor*)fillColor progress:(float)progress withRadius:(float)radius;
@end
