//
//  LZShareViewController.m
//  nutrition
//
//  Created by liu miao on 6/17/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZShareViewController.h"
#import <ShareSDK/ShareSDK.h>
@interface LZShareViewController ()

@end

@implementation LZShareViewController
@synthesize preInsertText;
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
        self.contentTextView.text = preInsertText;
        self.wordCountLabel.text = [NSString stringWithFormat:@"%i/140",[preInsertText length]];
    }
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.contentTextView becomeFirstResponder];
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
    
    id<ISSContent> publishContent = [ShareSDK content:self.contentTextView.text
                                       defaultContent:@""
                                                image:nil//[ShareSDK imageWithPath:imagePath]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
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
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请稍后再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                            [alert show];
                        }
                    }];

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
    [super viewDidUnload];
}
@end
