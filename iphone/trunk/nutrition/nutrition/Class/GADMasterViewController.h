//
//  GADMasterViewController.h
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
@interface GADMasterViewController : UIViewController {
    GADBannerView *adBanner_;
    BOOL didCloseWebsiteView_;
    BOOL isLoaded_;
    id currentDelegate_;
}
+(GADMasterViewController *)singleton;
-(void)resetAdView:(UIViewController *)rootViewController andListView :(UITableView *)listView;
-(void)removeAds;
@end
