//
//  LZAnalysislViewController.h
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZAnalysislViewController : UIViewController{
    NSString * csvFilePath;
}

@property (strong, nonatomic) IBOutlet UITextView *recommendTextView;
@end
