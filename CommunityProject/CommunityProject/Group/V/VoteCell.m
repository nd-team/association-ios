//
//  VoteCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VoteCell.h"

@implementation VoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.block(textField.text);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.chooseTF resignFirstResponder];
    return YES;
}
@end
