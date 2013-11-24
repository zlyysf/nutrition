//
//  XLCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NGCycleScrollViewDelegate;
@protocol NGCycleScrollViewDatasource;

@interface NGCycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
//    UIPageControl *_pageControl;
    
//    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
//@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDatasource:) id<NGCycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<NGCycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
-(void)scrollToPreviousPage;
-(void)scrollToNextPage;
@end

@protocol NGCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(NGCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol NGCycleScrollViewDatasource <NSObject>

@required
//- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end
