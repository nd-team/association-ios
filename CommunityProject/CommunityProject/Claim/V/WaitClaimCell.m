//
//  WaitClaimCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "WaitClaimCell.h"

@implementation WaitClaimCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    [self.upDownBtn setImage:[UIImage imageNamed:@"darkDown"] forState:UIControlStateNormal];
    [self.upDownBtn setImage:[UIImage imageNamed:@"darkUp"] forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)upDownClick:(id)sender {
    self.upDownBtn.selected = !self.upDownBtn.selected;
    if (self.upDownBtn.selected) {
        self.downHeightCons.constant = 45;
    }else{
        self.downHeightCons.constant = 0;
    }
    
}
//同意认领
- (IBAction)agreeClick:(id)sender {
    
}
//拒绝认领
- (IBAction)disagreeClick:(id)sender {
    
}
@end
