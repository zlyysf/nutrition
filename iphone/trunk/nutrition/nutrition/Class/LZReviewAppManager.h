//
//  LZReviewAppManager.h
//  nutrition
//
//  Created by liu miao on 6/13/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MFMailComposeViewControllerDelegator : NSObject{
    UIViewController* m_viewControllerForMail;
}
-(void)popEmailFeedbackDialog_withViewController:(UIViewController*)viewController;


@end



@interface LZReviewAppManager : NSObject<UIAlertViewDelegate>{
    MFMailComposeViewControllerDelegator *m_MFMailComposeViewControllerDelegator;
}
+(LZReviewAppManager*)SharedInstance;
-(void)popReviewOurAppAlertAccordingRules_withViewController:(UIViewController*)viewController;
-(void)reviewOurAppDirectly;
@end
