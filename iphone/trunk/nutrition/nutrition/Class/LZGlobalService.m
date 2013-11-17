//
//  LZGlobalService.m
//  nutrition
//
//  Created by liu miao on 11/7/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZGlobalService.h"
@implementation LZGlobalService
+(void)SetSubViewExternNone:(UIViewController *)viewController
{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
        viewController.extendedLayoutIncludesOpaqueBars = NO;
        viewController.modalPresentationCapturesStatusBarAppearance = NO;
        viewController.automaticallyAdjustsScrollViewInsets = NO;
        viewController.navigationController.navigationBar.translucent = NO;
    }
//#endif
}

@end
