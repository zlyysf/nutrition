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
#import "LZDataAccess.h"
@implementation LZNutrientionManager
@synthesize allNutritionDict;
+(LZNutrientionManager*)SharedInstance
{
    static dispatch_once_t LZNMOnce;
    static LZNutrientionManager * sharedInstance;
    dispatch_once(&LZNMOnce, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}
-(id)init
{
    if (self = [super init])
    {
        LZDataAccess *da = [LZDataAccess singleton];
        allNutritionDict = [da getNutrientInfoAs2LevelDictionary_withNutrientIds:nil];
    }
    return self;
}
-(NSDictionary *)getNutritionInfo:(NSString *)nutritionId
{
    NSDictionary *dict = [allNutritionDict objectForKey:nutritionId];
    return dict;
}
-(NSDictionary *)getAllNutritionDict
{
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:self.allNutritionDict];
    return  dict;
}
- (void)showNutrientInfo:(NSString *)nutrientId
{
    float duration = 0.5;
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    NSDictionary *dict = [allNutritionDict objectForKey:nutrientId];
    //NSLog(@"nutrient dict %@",dict);
    LZNutritionInfoView *viewtoAnimate = [[LZNutritionInfoView alloc]initWithFrame:CGRectMake(0, 20, screenSize.width, screenSize.height-20) andColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5] andInfo:dict delegate:self];

    LZAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.window addSubview:viewtoAnimate];
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
                    [NSNumber numberWithFloat:1.05f],
                    [NSNumber numberWithFloat:.95f],
                    [NSNumber numberWithFloat:1.f],
                    nil];
    
//    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    fadeIn.duration = duration * .4f;
//    fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
//    fadeIn.toValue = [NSNumber numberWithFloat:.7f];
//    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    fadeIn.fillMode = kCAFillModeForwards;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, nil]];
    group.delegate = nil;
    group.duration = duration;
    group.removedOnCompletion = YES;
    
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [viewtoAnimate.backView.layer addAnimation:group forKey:@"kFTAnimationPopIn"];

}
- (void)infoViewClosed:(LZNutritionInfoView *)infoView
{
    [infoView.layer removeAllAnimations];
    float duration = 0.3;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.75f],
                    nil];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.duration = duration; //* .4f;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //fadeOut.beginTime = duration * .6f;
    //fadeOut.fillMode = kCAFillModeForwards;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeOut, nil]];
    group.delegate = self;
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setValue:infoView.backView forKey:@"kViewToRemove"];
    [infoView.backView.layer addAnimation:group forKey:@"kFTAnimationPopOut"];
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
        LZNutritionInfoView *view = (LZNutritionInfoView*)((UIView*)[theAnimation valueForKey:@"kViewToRemove"]).superview;
        if(view)
        {
            [view removeFromSuperview];
        }
    }
}
@end
