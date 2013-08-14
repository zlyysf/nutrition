//
//  LZFoodCell.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFoodCell.h"
@implementation LZRecommendFoodCell
@synthesize cellFoodId;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
//{
//    LZKeyboardToolBar *keyboardToolbar = [[LZKeyboardToolBar alloc]initWithFrame:kKeyBoardToolBarRect doneButtonTitle:@"完成" delegate:self];
//    textField.inputAccessoryView = keyboardToolbar;
//    
//    //[textField becomeFirstResponder];
//    return YES;
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if(delegate && [delegate respondsToSelector:@selector(textFieldDidBeginEditingForId:textField:)])
//    {
//        [delegate textFieldDidBeginEditingForId:self.cellFoodId textField:self.foodAmountTextField];
//    }
//    
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if(delegate && [delegate respondsToSelector:@selector(textFieldDidReturnForId:andText:)])
//    {
//        [delegate textFieldDidReturnForId:self.cellFoodId andText:self.foodAmountTextField.text];
//    }
//    //return YES;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    //记录用量
//    
//    //    if(delegate && [delegate respondsToSelector:@selector(textFieldDidReturnForIndex:)])
//    //    {
//    //        [delegate textFieldDidReturnForIndex:self.cellIndexPath];
//    //    }
//    [textField resignFirstResponder];
//    return YES;
//    
//}// called when 'return' key pressed. return NO to
//-(void)toolbarKeyboardDone
//{
//    [self.foodAmountTextField resignFirstResponder];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted)
    {
        [self.foodNameLabel setTextColor:[UIColor whiteColor]];
    
        [self.foodUnitLabel setTextColor:[UIColor whiteColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelectedBack.png"]]];
    }
    else
    {
        [self.foodNameLabel setTextColor:[UIColor blackColor]];
        [self.foodUnitLabel setTextColor:[UIColor blackColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
    }
}
@end
