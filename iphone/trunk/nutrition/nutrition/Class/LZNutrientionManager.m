//
//  LZNutrientionManager.m
//  rgbCalculator
//
//  Created by liu miao on 6/19/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZNutrientionManager.h"
#import <QuartzCore/QuartzCore.h>
#import "LZAppDelegate.h"
@implementation LZNutrientionManager
+(LZNutrientionManager*)SharedInstance
{
    static dispatch_once_t LZNMOnce;
    static LZNutrientionManager * sharedInstance;
    dispatch_once(&LZNMOnce, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}
- (void)showNutrientInfo:(NSString *)nutrientId
{
    float duration = 0.5;
    LZNutritionInfoView *viewtoAnimate = [[LZNutritionInfoView alloc]initWithFrame:CGRectMake(50, 50, 50, 50) andColor:[UIColor blueColor] delegate:self];
    //[viewtoAnimate setBackgroundColor:[UIColor redColor]];
    //viewtoAnimate.tag = 202;
    LZAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.window addSubview:viewtoAnimate];

    
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.85f],
                    [NSNumber numberWithFloat:1.f],
                    nil];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration = duration * .4f;
    fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeIn.fillMode = kCAFillModeForwards;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeIn, nil]];
    group.delegate = nil;
    group.duration = duration;
    group.removedOnCompletion = YES;
    
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [viewtoAnimate.layer addAnimation:group forKey:@"kFTAnimationPopIn"];

}
- (void)infoViewClosed:(LZNutritionInfoView *)infoView
{
    [infoView.layer removeAllAnimations];
    float duration = 0.5;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.75f],
                    nil];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.duration = duration * .4f;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeOut.beginTime = duration * .6f;
    //fadeOut.fillMode = kCAFillModeForwards;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeOut, nil]];
    group.delegate = self;
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setValue:infoView forKey:@"kViewToRemove"];
    [infoView.layer addAnimation:group forKey:@"kFTAnimationPopOut"];
//    float duration = 0.5;
//    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    scale.duration = duration;
//    scale.removedOnCompletion = NO;
//    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
//                    [NSNumber numberWithFloat:1.2f],
//                    [NSNumber numberWithFloat:.75f],
//                    nil];
//    
//    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    fadeOut.duration = duration * .4f;
//    fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
//    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
//    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    fadeOut.beginTime = duration * .6f;
//    fadeOut.fillMode = kCAFillModeBoth;
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeOut, nil]];
//    group.delegate = self;
//    group.duration = duration;
//    group.removedOnCompletion = YES;
//    group.fillMode = kCAFillModeBoth;
//    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [infoView.layer addAnimation:group forKey:@"kFTAnimationPopOut"];
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if(flag)
    {
        LZNutritionInfoView *view = [theAnimation valueForKey:@"kViewToRemove"];
        if(view)
        {
            [view removeFromSuperview];
        }
    }
}
@end
