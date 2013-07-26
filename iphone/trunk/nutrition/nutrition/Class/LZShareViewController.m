//
//  LZShareViewController.m
//  nutrition
//
//  Created by liu miao on 6/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "MobClick.h"
@interface LZShareViewController ()

@end

@implementation LZShareViewController
@synthesize preInsertText,shareImageData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    UIImage *textImage = [UIImage imageNamed:@"setting_text_back.png"];
    UIImage *textBackImage = [textImage stretchableImageWithLeftCapWidth:30 topCapHeight:15];
    [self.contentBackgroundImage setImage:textBackImage];
    if (preInsertText != nil)
    {
        if ([preInsertText length]<= 140) {
            self.contentTextView.text = preInsertText;
            self.wordCountLabel.text = [NSString stringWithFormat:@"%i/140",[preInsertText length]];
        }
        else
        {
            NSString *content = [preInsertText substringToIndex:137];
            content = [content stringByAppendingString:@"..."];
            self.contentTextView.text = content;
            self.wordCountLabel.text = [NSString stringWithFormat:@"%i/140",[content length]];
        }
    }
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"微博分享页面"];
    [self.contentTextView becomeFirstResponder];
    if (self.shareImageData)
    {
        if (!self.previewImageView.image)
        {
            UIImage *shareImage = [UIImage imageWithData:self.shareImageData];
            [self.previewImageView setImage:shareImage];
            shareImage = nil;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"微博分享页面"];
}
- (void)textChanged:(NSNotification *)notification
{
    int length = [self.contentTextView.text length];
//    if(length == 0)
//    {
//        self.placeholderLabel.alpha = 1;
//    }
//    else
//    {
//        self.placeholderLabel.alpha = 0;
//    }
    self.wordCountLabel.text = [NSString stringWithFormat:@"%i/140",length];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //    NSCharacterSet *cs;
    //    cs = [[NSCharacterSet characterSetWithCharactersInString:] invertedSet];
    //    NSString *filtered =
    //    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    //    BOOL basic = [string isEqualToString:filtered];
    //    if (basic)
    //    {
    if ([text length]+[textView.text length]>140)
    {
        return NO;
    }
    return YES;
    //    }
    //    else {
    //        return NO;
    //    }
    
}

- (IBAction)clearButtonTapped:(id)sender {
    self.contentTextView.text = @"";
    self.wordCountLabel.text = [NSString stringWithFormat:@"%i/140",0];
}
- (IBAction)publishButtonTapped:(id)sender {
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"];
    
    if (self.previewImageView.image)
    {
        NSString *content = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([content length]==0)
        {
            content = @"来自@营养膳食指南";
        }
        UIImage *shareImage = self.previewImageView.image;
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:[ShareSDK jpegImageWithImage:shareImage quality:0.1]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeImage];
        shareImage = nil;
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            [self dismissModalViewControllerAnimated:YES];
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                            [alert show];
                        }
                    }];
    }

}
- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentTextView:nil];
    [self setContentBackgroundImage:nil];
    [self setWordCountLabel:nil];
    [self setPreviewImageView:nil];
    [super viewDidUnload];
}
@end
