//
//  IZValueSelectorView.h
//  IZValueSelector
//
//  Created by Iman Zarrabian on 02/11/12.
//  Copyright (c) 2012 Iman Zarrabian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZValueSelectorView;

@protocol IZValueSelectorViewDelegate <NSObject>

- (void)selector:(LZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index;

@end

@protocol IZValueSelectorViewDataSource <NSObject>
- (NSInteger)numberOfRowsInSelector:(LZValueSelectorView *)valueSelector;
- (UIView *)selector:(LZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger) index;
- (CGRect)rectForSelectionInSelector:(LZValueSelectorView *)valueSelector;
- (CGFloat)rowHeightInSelector:(LZValueSelectorView *)valueSelector;
- (CGFloat)rowWidthInSelector:(LZValueSelectorView *)valueSelector;
@end



@interface LZValueSelectorView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) IBOutlet id <IZValueSelectorViewDelegate> delegate;
@property (nonatomic,assign) IBOutlet id <IZValueSelectorViewDataSource> dataSource;
@property (nonatomic,assign) BOOL shouldBeTransparent;
@property (nonatomic,assign) BOOL horizontalScrolling;

@property (nonatomic,assign) BOOL debugEnabled;


- (void)reloadData;

@end
