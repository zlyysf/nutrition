//
//  LZFoodCell.m
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodCell.h"
@implementation LZFoodCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
//{
//    LZKeyboardToolBar *keyboardToolbar = [[LZKeyboardToolBar alloc]initWithFrame:kKeyBoardToolBarRect doneButtonTitle:@"完成" delegate:self];
//    textField.inputAccessoryView = keyboardToolbar;
//
//    //[textField becomeFirstResponder];
//    return YES;
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if(delegate && [delegate respondsToSelector:@selector(textFieldDidBeginEditingForIndex:textField:)])
//    {
//        [delegate textFieldDidBeginEditingForIndex:self.cellIndexPath textField:self.intakeAmountTextField];
//    }
//
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    if(delegate && [delegate respondsToSelector:@selector(textFieldDidReturnForIndex:andText:)])
//    {
//        [delegate textFieldDidReturnForIndex:self.cellIndexPath andText:self.intakeAmountTextField.text];
//    }
//    return YES;
//}
//- (IBAction)nameButtonTapped:(id)sender {
//    if(delegate && [delegate respondsToSelector:@selector(foodButtonTappedForIndex:)])
//    {
//        [self.delegate foodButtonTappedForIndex:self.cellIndexPath];
//    }
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    //记录用量
//    
////    if(delegate && [delegate respondsToSelector:@selector(textFieldDidReturnForIndex:)])
////    {
////        [delegate textFieldDidReturnForIndex:self.cellIndexPath];
////    }
//    [textField resignFirstResponder];
//    return YES;
//    
//}// called when 'return' key pressed. return NO to
//-(void)toolbarKeyboardDone
//{
//    [self.intakeAmountTextField resignFirstResponder];
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
        [self.foodAmountLabel setTextColor:[UIColor whiteColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelectedBack.png"]]];
    }
    else
    {
        [self.foodNameLabel setTextColor:[UIColor blackColor]];
        [self.foodAmountLabel setTextColor:[UIColor blackColor]];
        [self.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
        
    }
}

@end
