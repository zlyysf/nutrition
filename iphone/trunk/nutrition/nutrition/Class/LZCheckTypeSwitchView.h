//
//  LZCheckTypeSwitchView.h
//  nutrition
//
//  Created by liu miao on 10/8/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZCheckTypeSwitchView;
@protocol LZCheckTypeSwitchViewDelegate<NSObject>
- (void)switchViewClosed:(LZCheckTypeSwitchView *)switchView;
- (void)switchViewSubmitted:(LZCheckTypeSwitchView *)filterView selection:(NSString *)type;
@end
@interface LZCheckTypeSwitchView : UIView
- (id)initWithFrame:(CGRect)frame
            andInfo:(NSDictionary *)infoDict
           delegate:(id<LZCheckTypeSwitchViewDelegate>)switchDelegate;
@property (nonatomic,assign)id<LZCheckTypeSwitchViewDelegate>delegate;
@end
