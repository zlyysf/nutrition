//
//  GADMasterViewController.h
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdDelegateProtocol.h"
#import "GADBannerView.h"
@interface GADMasterViewController : UIViewController <BaiduMobAdViewDelegate>{
    //GADBannerView *adBanner_;
    BOOL didCloseWebsiteView_;
    BOOL isLoaded_;
    id currentDelegate_;
    BaiduMobAdView* sharedAdView;
}
+(GADMasterViewController *)singleton;
-(void)resetAdView:(UIViewController *)rootViewController andListView :(UIView *)superView;
//-(void)removeAds;
@end
