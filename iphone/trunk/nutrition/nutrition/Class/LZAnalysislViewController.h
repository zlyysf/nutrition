//
//  LZAnalysislViewController.h
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZAnalysislViewController : UIViewController<UIAlertViewDelegate>{
    NSString * csvFilePath;
    NSString * txtCalculateInfo;
    NSString * htmlCalculateInfo;
}
@property (strong, nonatomic) IBOutlet UIWebView *recommendWebViewAsTable;

//@property (strong, nonatomic) IBOutlet UITextView *recommendTextView;
@end
