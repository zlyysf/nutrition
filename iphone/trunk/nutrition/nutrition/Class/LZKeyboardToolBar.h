//
//  LZKeyboardToolBar.h
//  nutrition
//
//  Created by liu miao on 6/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LZKeyboardToolBarDelegate<NSObject>
-(void)toolbarKeyboardDone;
@end
@interface LZKeyboardToolBar : UIToolbar
@property (assign,nonatomic)id<LZKeyboardToolBarDelegate>delegate;
- (id)initWithFrame:(CGRect)frame
    doneButtonTitle:(NSString *)buttonTitle
           delegate:(id<LZKeyboardToolBarDelegate>)toolbarDelegate;
@end
