//
//  LZSliderByScrollView.m
//  trySome
//
//  Created by Yasofon on 14-2-11.
//  Copyright (c) 2014年 Yasofon. All rights reserved.
//

#import "LZSliderByScrollView.h"

@interface LZSliderByScrollView()<UIScrollViewDelegate>
@end



@implementation LZSliderByScrollView{
    NSArray *itemColorsTmpAry;
    NSNumber *nmToBeScrollToMark;
    NSDate *prevScrollTime;
    
}



@synthesize max;
@synthesize needReduceScrollingEvent;
@synthesize inDebugMode;
@synthesize needPointerImageView,needPointerLineView;
@synthesize PointerLineView,PointerImageView,ScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)_init{
    max = markMaxDef;
    needReduceScrollingEvent = TRUE;
    needPointerImageView = TRUE;
    needPointerLineView = FALSE; //TRUE;
    
    inDebugMode = false;
    
    [self initTmp];
}

-(void)initTmp
{
    if (itemColorsTmpAry == nil){
        itemColorsTmpAry = [NSArray arrayWithObjects:
                            [UIColor colorWithRed:243/255.f green:213/255.f blue:223/255.f alpha:0.5f],
                            [UIColor colorWithRed:237/255.f green:225/255.f blue:211/255.f alpha:0.5f],
                            nil];
        
    }
}


- (void)layoutSubviews {
    [self createViews];
    
    [super layoutSubviews];
}

-(void)createViews
{
    CGRect frameWhole = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    UIImageView *BgBorderImageView = [[UIImageView alloc] initWithFrame:frameWhole];
    NSString *bgBorderImagePath = [[NSBundle mainBundle] pathForResource:@"valuepicker_bg@2x" ofType:@"png"];
    UIImage *bgBorderImage = [UIImage imageWithContentsOfFile:bgBorderImagePath];
    [BgBorderImageView setImage:bgBorderImage];
    [self addSubview:BgBorderImageView];
    
    if (needPointerImageView){
        PointerImageView = [[UIImageView alloc] initWithFrame:frameWhole];
        NSString *pointerImagePath = [[NSBundle mainBundle] pathForResource:@"valuepicker_cover@2x" ofType:@"png"];
        UIImage *pointerImage = [UIImage imageWithContentsOfFile:pointerImagePath];
        [PointerImageView setImage:pointerImage];
        [self addSubview:PointerImageView];
    }
    
    if (needPointerLineView){
        float pointerLineHeight = self.bounds.size.height - markUnitMidHeight; //frameScrollView.size.height/2;
        float pointerLineWidth = markXianWidth*3;
        float pointerLineX = self.bounds.origin.x + (self.bounds.size.width-pointerLineWidth)/2;
        
        PointerLineView = [[UIView alloc]initWithFrame:CGRectMake(pointerLineX,0, pointerLineWidth, pointerLineHeight)];
        [PointerLineView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:PointerLineView];
    }
    
    CGRect frameScrollView = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    ScrollView = [[UIScrollView alloc] initWithFrame:frameScrollView];
    [self addSubview:ScrollView];
    
    
    //    ScrollView.backgroundColor = [UIColor greenColor];
    
    int markUnitItemsCount = max+1;
    float scrollViewContentW = frameScrollView.size.width + max*markUnitWidth;
    [ScrollView setContentSize:CGSizeMake(scrollViewContentW, frameScrollView.size.height)];
    
    for (int i=0; i<markUnitItemsCount; i++) {
        float markUnitX = frameScrollView.size.width/2 + i*markUnitWidth - markUnitWidth/2;
        CGRect markUnitFrame = CGRectMake(markUnitX, 0, markUnitWidth, frameScrollView.size.height);
        UIImageView *markUnitView = [[UIImageView alloc]initWithFrame:markUnitFrame];
        
        if (inDebugMode){
            if (itemColorsTmpAry!=nil)
                markUnitView.backgroundColor = itemColorsTmpAry[i%itemColorsTmpAry.count];
            else
                markUnitView.backgroundColor = [UIColor clearColor];
        }else{
            markUnitView.backgroundColor = [UIColor clearColor];
        }
        
        float markXianHeight = markUnitHeight;
        if (i%10==0){
            markXianHeight = markUnitBigHeight;
            
            NSString *markStr = [NSString stringWithFormat:@"%d",i];
            UIFont *labelFont = [UIFont systemFontOfSize:markLabelFontSize];
            CGSize calTextSize = [markStr sizeWithFont:labelFont constrainedToSize:CGSizeMake(MAXFLOAT, 0.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            //            CGRect labelFrame = CGRectMake(0,0, markLabelWidth, markLabelHeight);
            float labelX = (markUnitWidth - calTextSize.width)/2 ;
            CGRect labelFrame = CGRectMake(labelX,0, calTextSize.width, markLabelHeight);
            
            UILabel *markLabel = [[UILabel alloc] initWithFrame:labelFrame];
            [markLabel setText:markStr];
            [markLabel setTextColor:[UIColor blackColor]];
            [markLabel setFont:labelFont];
            markLabel.backgroundColor = [UIColor clearColor];
            [markUnitView addSubview:markLabel];
            
        }else if (i%5==0){
            markXianHeight = markUnitMidHeight;
        }
        
        UIView *markXian = [[UIView alloc]initWithFrame:CGRectMake((markUnitWidth-markXianWidth+1)/2,frameScrollView.size.height-markXianHeight-3, markXianWidth, markXianHeight)];
        [markXian setBackgroundColor:[UIColor blackColor]];
        [markUnitView addSubview:markXian];
        
        [ScrollView addSubview:markUnitView];
    }
    
    if (nmToBeScrollToMark != nil){
        [self scrollToGivenMarkInternal:[nmToBeScrollToMark intValue]];
    }
    
    if (ScrollView.delegate == nil)
        ScrollView.delegate = self;
}

-(void)scrollToGivenMark:(int)markIndex
{
    if (ScrollView == nil){
        nmToBeScrollToMark = [NSNumber numberWithInt:markIndex];
    }else{
        [self scrollToGivenMarkInternal:markIndex];
    }
}

-(void)scrollToGivenMarkInternal:(int)markIndex
{
    //int toX = self.bounds.size.width / 2 + markIndex*markUnitWidth - self.bounds.size.width / 2;
    int toX = markIndex*markUnitWidth;//由于我们的取值点是在正中，而滚动只是让这个点滚到左上角，而不是再滚半截到正中，所以得注意半截的偏移，但正好与前置的半截空白抵消。
    [ScrollView setContentOffset:CGPointMake(toX, 0) animated:YES];
}

-(void)moveForIntegerMarkWhenScrollStop_andIfNeedCallDelegate:(BOOL)needCallDelegate
{
    float markIndex1 = ScrollView.contentOffset.x / markUnitWidth;
    float markIndex2 = roundf(markIndex1);
    if (markIndex2==markIndex1){
        //integer index, do nothing
    }else{
        [self scrollToGivenMarkInternal:markIndex2];
    }
    
    if(needCallDelegate && self.delegate!=nil && [self.delegate respondsToSelector:@selector(scrollStopped:)])
    {
        [self.delegate scrollStopped:markIndex2];
    }
}

-(int)getCurrentMark
{
    return (int)roundf(ScrollView.contentOffset.x / markUnitWidth);
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView     // any offset changes
{
    //    NSLog(@"scrollViewDidScroll x=%f",scrollView.contentOffset.x);
    NSDate *now = [NSDate date];
    if (prevScrollTime == nil){
        prevScrollTime = now;
    }else{
        NSTimeInterval nowTimeInterval = [now timeIntervalSince1970];
        NSTimeInterval prevTimeInterval = [prevScrollTime timeIntervalSince1970];
        NSLog(@"scrollViewDidScroll x=%f nowTimeInterval=%f",scrollView.contentOffset.x,nowTimeInterval);
        if (needReduceScrollingEvent){
            if (nowTimeInterval - prevTimeInterval >= AtLeastTimeSpanBySecondWhenReduceScrollEvent){
                prevScrollTime = now;
                //to send scrolling event
                if( self.delegate!=nil && [self.delegate respondsToSelector:@selector(scrolling:)])
                {
                    [self.delegate scrolling:[self getCurrentMark]];
                }
            }else{
                //not send scrolling event
            }
        }else{
            if( self.delegate!=nil && [self.delegate respondsToSelector:@selector(scrolling:)])
            {
                [self.delegate scrolling:[self getCurrentMark]];
            }
        }
    }
    //    NSLog(@"scrollViewDidScroll x=%f nowTimeInterval=%f",scrollView.contentOffset.x,nowTimeInterval);
}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2); // any zoom scale changes


// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
}
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    //.............
    NSLog(@"scrollViewWillEndDragging x=%f, velocity=[%f,%f]",scrollView.contentOffset.x,velocity.x,velocity.y);
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging x=%f, decelerate=%d",scrollView.contentOffset.x,decelerate);
    if (!decelerate){
        [self moveForIntegerMarkWhenScrollStop_andIfNeedCallDelegate:TRUE];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView   // called on finger up as we are moving
{
    NSLog(@"scrollViewWillBeginDecelerating x=%f",scrollView.contentOffset.x);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView      // called when scroll view grinds to a halt
{
    NSLog(@"scrollViewDidEndDecelerating x=%f",scrollView.contentOffset.x);
    [self moveForIntegerMarkWhenScrollStop_andIfNeedCallDelegate:TRUE];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
{
    NSLog(@"scrollViewDidEndScrollingAnimation x=%f",scrollView.contentOffset.x);
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(scrollStopped:)])
    {
        [self.delegate scrollStopped:[self getCurrentMark]];
    }
}
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView     // return a view that will be scaled. if delegate returns nil, nothing happens

//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2) // called before the scroll view begins zooming its content

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale // scale between minimum and maximum. called after any 'bounce' animations

//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView   // return a yes if you want to scroll to the top. if not defined, assumes YES

//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView      // called when scrolling animation finished. may be called immediately if already at top


@end
