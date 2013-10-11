//
//  LZCheckTypeSwitchView.m
//  nutrition
//
//  Created by liu miao on 10/8/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZCheckTypeSwitchView.h"

@implementation LZCheckTypeSwitchView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
            andInfo:(NSDictionary *)infoDict
           delegate:(id<LZCheckTypeSwitchViewDelegate>)switchDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView  *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapped:)];
        [tapView addGestureRecognizer:tapGesture];
        [self addSubview:tapView];
        [tapView setBackgroundColor:[UIColor clearColor]];
        UIImageView *outerView = [[UIImageView alloc]initWithFrame:CGRectMake(59, 34, 202, 162)];
        [outerView setImage:[UIImage imageNamed:@"switch_back.png"]];
        [self addSubview:outerView];
        // Initialization code
        self.delegate = switchDelegate;
        
        NSArray *array = [infoDict objectForKey:@"buttonTitles"];
        NSString *currentType = [infoDict objectForKey:@"currentType"];
        int index = [array indexOfObject:currentType];
        
        UIButton *buttonShangWu = [[UIButton alloc]initWithFrame:CGRectMake(59, 44, 202, 50)];
        [buttonShangWu setTitle:NSLocalizedString(@"healthcheck_viewtitle0",@"上午诊断") forState:UIControlStateNormal];
        [buttonShangWu.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [buttonShangWu.titleLabel setTextColor:[UIColor whiteColor]];
        buttonShangWu.tag = 100;
        [buttonShangWu addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonShangWu setBackgroundImage:[UIImage imageNamed:@"switch_top.png"] forState:UIControlStateHighlighted];
        if (index == 0)
        {
            [buttonShangWu setBackgroundImage:[UIImage imageNamed:@"switch_top.png"] forState:UIControlStateNormal];
        }
        
        UIButton *buttonXiaWu = [[UIButton alloc]initWithFrame:CGRectMake(59, 95, 202, 50)];
        [buttonXiaWu setTitle:NSLocalizedString(@"healthcheck_viewtitle1",@"下午诊断") forState:UIControlStateNormal];
        [buttonXiaWu.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [buttonXiaWu.titleLabel setTextColor:[UIColor whiteColor]];
        buttonXiaWu.tag = 101;
        [buttonXiaWu addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonXiaWu setBackgroundImage:[UIImage imageNamed:@"switch_middle.png"] forState:UIControlStateHighlighted];
        if (index == 1)
        {
            [buttonXiaWu setBackgroundImage:[UIImage imageNamed:@"switch_middle.png"] forState:UIControlStateNormal];
        }

        UIButton *buttonShuiQian = [[UIButton alloc]initWithFrame:CGRectMake(59, 146, 202, 50)];
        [buttonShuiQian setTitle:NSLocalizedString(@"healthcheck_viewtitle2",@"睡前诊断") forState:UIControlStateNormal];
        [buttonShuiQian.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [buttonShuiQian.titleLabel setTextColor:[UIColor whiteColor]];
        buttonShuiQian.tag = 102;
        [buttonShuiQian addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonShuiQian setBackgroundImage:[UIImage imageNamed:@"switch_bottom.png"] forState:UIControlStateHighlighted];
        if (index == 2)
        {
            [buttonShuiQian setBackgroundImage:[UIImage imageNamed:@"switch_bottom.png"] forState:UIControlStateNormal];
        }

        [self addSubview:buttonShangWu];
        [self addSubview:buttonXiaWu];
        [self addSubview:buttonShuiQian];
}
    return self;
}
-(void)userTapped:(UITapGestureRecognizer*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchViewClosed:)])
    {
        [self.delegate switchViewClosed:self];
    }
}
-(void)typeButtonTapped:(UIButton *)sender
{
    NSArray *array = [NSArray arrayWithObjects:@"上午",@"下午",@"睡前", nil];
    int tag = sender.tag-100;
    NSString *selectedType = [array objectAtIndex:tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchViewSubmitted:selection:)])
    {
        [self.delegate switchViewSubmitted:self selection:selectedType];
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
