//
//  LZShareViewController.h
//  nutrition
//
//  Created by liu miao on 6/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZShareViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UIImageView *contentBackgroundImage;
@property (strong, nonatomic) IBOutlet UILabel *wordCountLabel;
@property (strong,nonatomic)NSString *preInsertText;
@property (strong,nonatomic)NSData *shareImageData;
@property (strong, nonatomic) IBOutlet UIImageView *previewImageView;
@end
