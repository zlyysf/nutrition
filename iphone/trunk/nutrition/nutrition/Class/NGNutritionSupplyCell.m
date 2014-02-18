//
//  LZNutritionSupplyCell.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGNutritionSupplyCell.h"
#import "LZNutrientionManager.h"

@implementation NGNutritionSupplyCell


//@synthesize nutrientId;
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//- (IBAction)nameButtonTapped:(id)sender {
//    [[LZNutrientionManager SharedInstance]showNutrientInfo:self.nutrientId];
//}



@synthesize nutrientId;
@synthesize enableHighlighted;
//@synthesize enableAdd ;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
//    if (enableHighlighted){
//        if (selected)
//        {
//            //FAIL
////            [self setBackgroundColor:[UIColor colorWithRed:61/255.f green:175/255.f blue:45/255.f alpha:1.0f]];
////            [self.contentView setBackgroundColor:[UIColor colorWithRed:61/255.f green:175/255.f blue:45/255.f alpha:1.0f]];
//            
//            //FAIL
////            UIColor *selectedBgColor = [UIColor colorWithRed:61/255.f green:175/255.f blue:45/255.f alpha:1.0f];
////            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
////            selectedBackgroundView.backgroundColor = selectedBgColor;
////            self.selectedBackgroundView = selectedBackgroundView;
//
//        }
//        else
//        {
////            [self setBackgroundColor:[UIColor clearColor]];
////            [self.contentView setBackgroundColor:[UIColor clearColor]];
//        }
//    }
}

////可以用，但是不是设置与highlight有关的属性，而是直接的显示属性
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    if (enableHighlighted){
//        if (highlighted)
//        {
//            //            [self setBackgroundColor:[UIColor colorWithRed:61/255.f green:175/255.f blue:45/255.f alpha:1.0f]];//Have effect, but not good, same as self.contentView
//            [self.contentView setBackgroundColor:[UIColor colorWithRed:61/255.f green:175/255.f blue:45/255.f alpha:1.0f]];//Have effect, but not good
//            self.nutritionNameLabel.textColor = [UIColor whiteColor];
//            self.nutrientSupplyLabel.textColor = [UIColor whiteColor];
//        }
//        else
//        {
//            //            [self setBackgroundColor:[UIColor clearColor]];
//            [self.contentView setBackgroundColor:[UIColor clearColor]];
//            self.nutritionNameLabel.textColor = [UIColor blackColor];
//            self.nutrientSupplyLabel.textColor = [UIColor blackColor];
//        }
//    }
//}


- (void)layoutSubviews{
//    [self adjustViewsAccordingFlags];//will let progress have black content part
}


//-(void)adjustViewsAccordingFlags
//{
//    if (self.enableAdd){
//        self.addSignImageView.hidden = false;
//    }else{
//        self.addSignImageView.hidden = true;
//        CGRect frameProgress = self.nutritionProgressView.frame;
//        float widthAdjust = 320 - frameProgress.origin.x - 10;
//        if (widthAdjust != frameProgress.size.width){
//            frameProgress.size.width = widthAdjust;
//            self.nutritionProgressView.frame = frameProgress;
//        }
//    }
//}






@end















