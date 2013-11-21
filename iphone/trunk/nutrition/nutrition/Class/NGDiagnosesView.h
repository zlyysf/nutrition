//
//  NGDiagnosesView.h
//  nutrition
//
//  Created by liu miao on 11/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGDiagnosesView : UIView
-(float)displayForFont:(UIFont *)font maxWidth:(float)maxWidth horizonPadding:(float)horizonPadding verticalPadding:(float)verticalPadding imageMargin:(float)imageMargin bottomMargin:(float)bottomMargin textArray:(NSArray *)textArray selectedColor:(UIColor *)color;
@end
