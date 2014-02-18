//
//  LZSliderByScrollView.h
//  trySome
//
//  Created by Yasofon on 14-2-11.
//  Copyright (c) 2014年 Yasofon. All rights reserved.
//

#import <UIKit/UIKit.h>


#define markMin 0
#define markMaxDef 1000
#define markUnit 1
#define markUnitMid 5
#define markUnitBig 10

//#define bestWholeWidth 320
#define bestWholeHeight 50

#define markUnitWidth 8

#define markUnitHeight 10
#define markUnitMidHeight 15
#define markUnitBigHeight 20

#define markLabelFontSize 12
//#define markLabelWidth 30
#define markLabelHeight 15

#define markXianWidth 1
#define AtLeastTimeSpanBySecondWhenReduceScrollEvent 0.1f

@class LZSliderByScrollView;

@protocol LZSliderByScrollViewDelegate <NSObject>

- (void)scrollStopped:(int)curMark;
- (void)scrolling:(int)curMark;

@end



@interface LZSliderByScrollView : UIView

@property(nonatomic,assign)NSUInteger max;
//@property(nonatomic,assign)NSUInteger min;
@property(nonatomic,assign)BOOL needReduceScrollingEvent;

@property (nonatomic,assign) IBOutlet id <LZSliderByScrollViewDelegate> delegate;


@property(nonatomic,assign)BOOL inDebugMode;

@property(nonatomic,assign)BOOL needPointerImageView;
@property(nonatomic,assign)BOOL needPointerLineView;

@property(nonatomic,strong)UIView *PointerLineView;
@property(nonatomic,strong)UIImageView *PointerImageView;
@property(nonatomic,strong)UIScrollView *ScrollView;





//@property(nonatomic,strong)UIColor *scaleBgColor;
//@property(nonatomic,strong)UIColor *arrowColor;
//@property(nonatomic,strong)UIColor *disableStateTextColor;
//@property(nonatomic,strong)UIColor *selectedStateTextColor;
//@property(nonatomic,strong)UIColor *sliderBorderColor;

-(void)scrollToGivenMark:(int)markIndex;
-(int)getCurrentMark;


@end
