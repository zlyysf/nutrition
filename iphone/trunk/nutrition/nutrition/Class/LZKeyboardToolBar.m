//
//  LZKeyboardToolBar.m
//  nutrition
//
//  Created by liu miao on 6/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZKeyboardToolBar.h"

@implementation LZKeyboardToolBar
@synthesize donedelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
    doneButtonTitle:(NSString *)buttonTitle
           delegate:(id<LZKeyboardToolBarDelegate>)toolbarDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.donedelegate = toolbarDelegate;
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					  target:nil
																					  action:nil];
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc]initWithTitle:buttonTitle style:UIBarButtonItemStyleDone target:self action:@selector(textFieldDone)];
        NSArray *items = [[NSArray alloc]initWithObjects:spaceBarItem,doneButtonItem, nil];
        self.items = items;
        self.barStyle = UIBarStyleDefault;
        self.translucent = YES;
    }
    return self;

}
- (void)textFieldDone
{
    if (self.donedelegate && [self.donedelegate respondsToSelector:@selector(toolbarKeyboardDone)])
    {
        [self.donedelegate toolbarKeyboardDone];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
