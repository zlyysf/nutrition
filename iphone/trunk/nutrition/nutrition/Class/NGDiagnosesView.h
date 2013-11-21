//
//  NGDiagnosesView.h
//  nutrition
//
//  Created by liu miao on 11/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NGDiagnosesViewDelegate<NSObject>
-(void)userSelectedItem:(NSString *)text forIndexPath:(NSIndexPath*)indexPath;
@end
@interface NGDiagnosesView : UIView
-(float)displayForFont:(UIFont *)font maxWidth:(float)maxWidth horizonPadding:(float)horizonPadding verticalPadding:(float)verticalPadding imageMargin:(float)imageMargin bottomMargin:(float)bottomMargin textArray:(NSArray *)textArray selectedColor:(UIColor *)color;
@property (strong,nonatomic)NSIndexPath *cellIndex;
@property (strong,nonatomic)UIColor *selectColor;
@property (assign,nonatomic)id<NGDiagnosesViewDelegate> delegate;
@end
