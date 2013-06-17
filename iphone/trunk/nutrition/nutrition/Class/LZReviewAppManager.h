//
//  LZReviewAppManager.h
//  nutrition
//
//  Created by liu miao on 6/13/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZReviewAppManager : NSObject<UIAlertViewDelegate>
+(LZReviewAppManager*)SharedInstance;
-(void)popReviewOurAppAlertAccordingRules;
-(void)reviewOurAppDirectly;
@end
