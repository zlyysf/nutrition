//
//  LZRecommendFilterView.h
//  nutrition
//
//  Created by liu miao on 7/16/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZRecommendFilterView;
@protocol LZRecommendFilterViewDelegate<NSObject>
- (void)filterViewCanceled:(LZRecommendFilterView *)filterView;
- (void)filterViewSubmitted:(LZRecommendFilterView *)filterView forFilterInfo:(NSArray *)filterInfo;
@end
@interface LZRecommendFilterView : UIView
- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor*)backColor
         filterInfo:(NSArray*)filterInfo
            tipsStr:(NSString *)title
           delegate:(id<LZRecommendFilterViewDelegate>)filterDelegate;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIButton *submitButton;
@property (nonatomic,strong)UIButton *selectallButton;
@property (nonatomic,strong)NSMutableArray *filterArray;
@property (nonatomic,assign)id<LZRecommendFilterViewDelegate>delegate;
@end
