//
//  MessageCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.agreeBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.agreeBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateDisabled];
    [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"disagreeBtn"] forState:UIControlStateDisabled];
    [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"applicationBtn"] forState:UIControlStateNormal];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setAppModel:(ApplicationFriendsModel *)appModel{
    _appModel = appModel;
    self.nameLabel.text = _appModel.nickname;
    self.msgLabel.text = _appModel.addFriendMessage;
    NSString * encodeUrl = [NSString stringWithFormat:@"http://192.168.0.209:90/%@",[ImageUrl changeUrl:_appModel.userPortraitUrl]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    self.userIdLabel.text = _appModel.userId;
    switch ([_appModel.status intValue]) {
        case 0:
            [self.agreeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            self.agreeBtn.enabled = NO;
            break;
        case 1:
            [self.agreeBtn setTitle:@"已同意" forState:UIControlStateNormal];
            self.agreeBtn.enabled = NO;
            break;
        case 2:
            [self.agreeBtn setTitle:@"已忽略" forState:UIControlStateNormal];
            self.agreeBtn.enabled = NO;
            break;
        case 3:
            [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
            self.agreeBtn.enabled = YES;
            break;
        default:
            break;
    }

}
- (IBAction)agreeClick:(id)sender {
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    //同意好友申请
    UIButton * button = (UIButton *)sender;
    MessageCell * cell = (MessageCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.myTableView indexPathForCell:cell];
    ApplicationFriendsModel * model = self.dataArr[indexPath.row];
    NSString * fId = model.userId;
    NSString * status = @"1";
    NSDictionary * dic = @{@"userId":userId,@"friendUserId":fId,@"status":status};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AgreeFriend" object:dic];

}
@end
