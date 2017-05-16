//
//  GroupMessageCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupMessageCell.h"

@implementation GroupMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setButtonStatus:self.agreeBtn];
    [self setButtonStatus:self.unseeBtn];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;

}
-(void)setButtonStatus:(UIButton *)btn{
    [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateDisabled];
    [btn setBackgroundImage:[UIImage imageNamed:@"disagreeBtn"] forState:UIControlStateDisabled];
    [btn setBackgroundImage:[UIImage imageNamed:@"applicationBtn"] forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setGroupModel:(GroupApplicationModel *)groupModel{
    _groupModel = groupModel;
    self.nameLabel.text = _groupModel.nickname;
    self.msgLabel.text = _groupModel.content;
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_groupModel.avatarImage]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    self.userIdLabel.text = _groupModel.userId;
    if (_groupModel.status == nil) {
        [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        self.agreeBtn.enabled = YES; 
    }else{
        switch ([_groupModel.status intValue]) {
            case 0:
                [self.agreeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                self.agreeBtn.enabled = NO;
                break;
            case 1:
                [self.agreeBtn setTitle:@"已同意" forState:UIControlStateNormal];
                self.agreeBtn.enabled = NO;
                break;
            case 2:
                [self.unseeBtn setTitle:@"已忽略" forState:UIControlStateNormal];
                self.unseeBtn.enabled = NO;
                break;
            case 3:
                [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
                self.agreeBtn.enabled = YES;
                break;
            default:
                break;
        }
 
    }
}
-(void)setTwoModel:(ApplicationTwoModel *)twoModel{
    _twoModel = twoModel;
    self.nameLabel.text = _twoModel.nickname;
    self.msgLabel.text = [NSString stringWithFormat:@"邀请人是：%@(%@)",_twoModel.pullNickname,_twoModel.pullUserid];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_twoModel.userPortraitUrl]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    self.userIdLabel.text = _twoModel.userId;

}
- (IBAction)agreeClick:(id)sender {
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    //同意好友申请
    UIButton * button = (UIButton *)sender;
    GroupMessageCell * cell = (GroupMessageCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.myTableView indexPathForCell:cell];
    NSString * status = @"1";
    NSDictionary * dic = nil;
    if (indexPath.section == 0) {
        GroupApplicationModel * model = self.dataArr[indexPath.row];
        NSString * fId = model.userId;
        dic = @{@"groupUserId":userId,@"userId":fId,@"status":status,@"groupId":self.groupId};
    }else{
        ApplicationTwoModel * app = self.dataTwoArr[indexPath.row];
        NSString * fId = app.userId;
        dic = @{@"groupUserId":userId,@"userId":fId,@"status":status,@"groupId":self.groupId};
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AgreeGroupMessage" object:dic];

}
- (IBAction)unseeClick:(id)sender {
        NSString * userId = [DEFAULTS objectForKey:@"userId"];
        //忽略好友申请
        UIButton * button = (UIButton *)sender;
        GroupMessageCell * cell = (GroupMessageCell *)[[button superview]superview];
        NSIndexPath * indexPath = [self.myTableView indexPathForCell:cell];
        NSString * status = @"2";
        NSDictionary * dic = nil;
        if (indexPath.section == 0) {
            GroupApplicationModel * model = self.dataArr[indexPath.row];
            NSString * fId = model.userId;
            dic = @{@"groupUserId":userId,@"userId":fId,@"status":status,@"groupId":self.groupId};
        }else{
            ApplicationTwoModel * app = self.dataTwoArr[indexPath.row];
            NSString * fId = app.userId;
            dic = @{@"groupUserId":userId,@"userId":fId,@"status":status,@"groupId":self.groupId};
        }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"OverlookMessage" object:dic];

}

@end
