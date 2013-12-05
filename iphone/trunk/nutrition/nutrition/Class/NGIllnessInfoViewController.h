//
//  NGIllnessInfoViewController.h
//  nutrition
//
//  Created by liu miao on 12/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGIllnessInfoViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong,nonatomic) NSString *illnessURL;
@end
