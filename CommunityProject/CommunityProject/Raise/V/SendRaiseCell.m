//
//  SendRaiseCell.m
//  CommunityProject
//
//  Created by bjike on 2017/8/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SendRaiseCell.h"

@implementation SendRaiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.titleTF resignFirstResponder];
    self.block(self.titleTF.text);
    return YES;
}
@end
