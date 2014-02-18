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
    float drawingBackRadius;
    float drawingFillRadius;
    BOOL needDisplay;
}
@property (nonatomic,strong)UILabel *contentLabel;

//传rect是个坏方式
- (void)drawProgressForRect:(CGRect)rect backgroundColor:(UIColor*)backColor fillColor:(UIColor*)fillColor progress:(float)progress withBackRadius:(float)backRadius fillRadius:(float)fillRadius;

- (void)drawProgress_with_backgroundColor:(UIColor*)backColor fillColor:(UIColor*)fillColor progress:(float)progress withBackRadius:(float)backRadius fillRadius:(float)fillRadius;
@end
