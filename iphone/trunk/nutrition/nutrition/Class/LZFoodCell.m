//
//  LZFoodCell.m
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodCell.h"

@implementation LZFoodCell
@synthesize cellIndexPath;
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    //[textField becomeFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(delegate && [delegate respondsToSelector:@selector(textFieldDidReturnForIndex:andText:)])
    {
        [delegate textFieldDidReturnForIndex:self.cellIndexPath andText:self.intakeAmountTextField.text];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //记录用量
    
//    if(delegate && [delegate respondsToSelector:@selector(textFieldDidReturnForIndex:)])
//    {
//        [delegate textFieldDidReturnForIndex:self.cellIndexPath];
//    }
    [textField resignFirstResponder];
    return YES;
    
}// called when 'return' key pressed. return NO to

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
