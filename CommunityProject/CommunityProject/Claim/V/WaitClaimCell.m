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
    self.downHeightCons.constant = 0;
    self.downView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOtherModel:(OthersClaimModel *)otherModel{
    _otherModel = otherModel;
    self.nameLabel.text = _otherModel.nickname;
    self.contentLabel.text = [NSString stringWithFormat:@"尝试认领你是否让%@认领成功？",otherModel.nickname];

}
- (IBAction)upDownClick:(id)sender {
    self.upDownBtn.selected = !self.upDownBtn.selected;
    if (self.upDownBtn.selected) {
        self.downHeightCons.constant = 45;
        self.downView.hidden = NO;
    }else{
        self.downHeightCons.constant = 0;
        self.downView.hidden = YES;
    }
    //刷新UI
    self.block();
    
}
//同意认领
- (IBAction)agreeClick:(id)sender {
    
    UIButton * button = (UIButton *)sender;
    WaitClaimCell * cell = (WaitClaimCell *)[[[button superview]superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OthersClaimModel * model = self.dataThreeArr[indexPath.row];
    NSDictionary * dict = @{@"userId":self.userId,@"claimUserId":model.userId,@"status":@"1"};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AgreeClaimOther" object:dict];
    
}
//拒绝认领
- (IBAction)disagreeClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    WaitClaimCell * cell = (WaitClaimCell *)[[[button superview]superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OthersClaimModel * model = self.dataThreeArr[indexPath.row];
    NSDictionary * dict = @{@"userId":self.userId,@"claimUserId":model.userId,@"status":@"0"};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DisAgreeClaimOther" object:dict];

}
@end
