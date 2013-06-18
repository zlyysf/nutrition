//
//  GADMasterViewController.m
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "GADMasterViewController.h"
#import <AdSupport/ASIdentifierManager.h>

//#define MY_BANNER_UNIT_ID @"a14fb773a49c5c9"//a14f0800ac9dfad。a14fb76d4362e2a
//#define MY_BANNER_UNIT_ID @"a151346bbb1e935"//zly quiz awesome
#define MY_BANNER_UNIT_ID @"a15138373387ee2"//lingzhi.mobile Quiz Awesome
//这里写你的id    admob上注册应用后获取自己的id
//#define     IsEnvironmentProd 0
@interface GADMasterViewController ()<GADBannerViewDelegate>

@end

@implementation GADMasterViewController

+(GADMasterViewController *)singleton {
    static dispatch_once_t pred;
    static GADMasterViewController *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[GADMasterViewController alloc] init];
    });
    return shared;
}
-(id)init {
    if (self = [super init]) {
        adBanner_ = [[GADBannerView alloc]
                     initWithFrame:CGRectMake(0.0,0.0,
                                              CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                              CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
        NSLog(@"admob view width %f ,height %f",adBanner_.frame.size.width,adBanner_.frame.size.height);//CGSizeFromGADAdSize(kGADAdSizeBanner).height
        // Has an ad request already been made
        isLoaded_ = NO;
    }
    return self;
}

-(NSString*)getAdIdentifier{
    // Print IDFA (from AdSupport Framework) for iOS 6 and UDID for iOS < 6.
    NSString *idStr ;
    if (NSClassFromString(@"ASIdentifierManager")) {
        idStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    } else {
        idStr = [[UIDevice currentDevice] uniqueIdentifier];
    }
    return idStr;
}

-(void)resetAdView:(UIViewController *)rootViewController andListView :(UITableView *)listView {
    // Always keep track of currentDelegate for notification forwarding
    currentDelegate_ = rootViewController;
    // Ad already requested, simply add it into the view
    if (isLoaded_) {
        [listView.tableFooterView addSubview:adBanner_];

    } else {
        
        adBanner_.delegate = self;
        adBanner_.rootViewController = rootViewController;
        adBanner_.adUnitID = MY_BANNER_UNIT_ID;
        
        [self adBannerLoadRequest];

        [listView.tableFooterView addSubview:adBanner_];
        isLoaded_ = YES;
    }
}
-(void)adBannerLoadRequest
{
    GADRequest *request = [GADRequest request];
//    if (! IsEnvironmentProd){
//        // Add your device/simulator test identifiers here.
//        NSString * deviceId = [self getAdIdentifier ];
//        request.testDevices = [NSArray arrayWithObjects:
////                                   @"423C53E8-D67E-5E20-B37B-1BE8961F00BD", @"423c53e8d67e5e20b37b1be8961f00bd00000000", //zly simulator
////                                   @"D93B219A-2444-5340-93DC-80ED64662227", @"d93b219a2444534093dc80ed6466222700000000", //lm simulator
////                                   @"44132976c611d8bab02bc80e63076b56224826f4" //zly itouch
//                               deviceId,
//                               nil];
//    }
    
    [adBanner_ loadRequest:request];
}



-(void)removeAds
{
    adBanner_.delegate = nil;
    [adBanner_ removeFromSuperview];
}
- (void)adViewDidReceiveAd:(GADBannerView *)view {
    if (adBanner_.hasAutoRefreshed)
    {
        NSLog(@"hasAutoRefreshed YES");
    }
    else
    {
        NSLog(@"hasAutoRefreshed NO");
    }
    if ([currentDelegate_ respondsToSelector:@selector(adViewDidReceiveAd:)]) {
        [currentDelegate_ adViewDidReceiveAd:view];
    }
}
- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Admob Error %@",[error description]);
    if (adBanner_.hasAutoRefreshed)
    {
        NSLog(@"hasAutoRefreshed YES");
    }
    else
    {
        NSLog(@"hasAutoRefreshed NO");
    }
    NSTimeInterval delaySec = 60.0;
    [self performSelector:@selector(adBannerLoadRequest) withObject:self afterDelay:delaySec];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
