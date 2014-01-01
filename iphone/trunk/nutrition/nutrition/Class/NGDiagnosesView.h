//
//  NGDiagnosesView.h
//  nutrition
//
//  Created by liu miao on 11/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NGDiagnosesViewDelegate<NSObject>
-(void)ItemState:(BOOL)state tag:(int )tag forIndexPath:(NSIndexPath*)indexPath;
@end
@interface NGDiagnosesView : UIView
-(void)displayForFont:(UIFont *)font maxWidth:(float)maxWidth horizonPadding:(float)horizonPadding verticalPadding:(float)verticalPadding imageMargin:(float)imageMargin bottomMargin:(float)bottomMargin textArray:(NSArray *)textArray selectedColor:(UIColor *)color itemStateArray:(NSMutableArray *)stateArray heightArray:(NSArray *)heightArray isChinese:(BOOL)isChinese;
@property (strong,nonatomic)NSIndexPath *cellIndex;
@property (strong,nonatomic)UIColor *selectColor;
@property (strong,nonatomic)NSMutableArray *itemStateArray;
@property (assign,nonatomic)id<NGDiagnosesViewDelegate> delegate;
@end
