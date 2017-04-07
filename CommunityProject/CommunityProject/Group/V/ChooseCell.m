//
//  ChooseCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/31.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChooseCell.h"

@implementation ChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateNormal];
    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"selBtn"] forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chooseClick:(id)sender {
    self.chooseBtn.selected = !self.chooseBtn.selected;
    UIButton * button = (UIButton *)sender;
    ChooseCell * cell = (ChooseCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    switch (self.isSingle) {
        case 1:
        {
            //单选 选择管理员 群组成员
            MemberListModel * model = self.dataArr[indexPath.section][indexPath.row];
            if (self.chooseBtn.selected) {
                self.managerBlock(model.userId,nil,YES,NO);
                //单选需要实现的方法
                self.selectBlock(indexPath);
            }
        }
            break;
          case 2:
        {
            //多选 新建群聊 好友列表
            FriendsListModel * model = self.dataArr[indexPath.section][indexPath.row];
            if (self.chooseBtn.selected) {
                self.managerBlock(model.userId,model.userPortraitUrl,NO,NO);
            }else{
                //移除这个ID
                self.managerBlock(model.userId,model.userPortraitUrl,NO,YES);
            }
        }
            break;
            
            case 3:
        {
            //多选 拉人 好友列表
            FriendsListModel * model = self.dataArr[indexPath.section][indexPath.row];
            if (self.chooseBtn.selected) {
                self.managerBlock(model.userId,model.userPortraitUrl,NO,NO);
            }else{
                //移除这个ID
                self.managerBlock(model.userId,model.userPortraitUrl,NO,YES);
            }
        }
            
            break;
            
        default:
        {
            //多选 踢人 群组成员
            MemberListModel * model = self.dataArr[indexPath.section][indexPath.row];
            if (self.chooseBtn.selected) {
                self.managerBlock(model.userId,model.userPortraitUrl,NO,NO);
            }else{
                //移除这个ID
                self.managerBlock(model.userId,model.userPortraitUrl,NO,YES);
            }
        }
            break;
    }
}
-(void)setMemberModel:(MemberListModel *)memberModel{
    _memberModel = memberModel;
    self.nameLabel.text = _memberModel.userName;
    NSString *  str = [ImageUrl changeUrl:_memberModel.userPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];

}
-(void)setListModel:(FriendsListModel *)listModel{
    _listModel = listModel;
    if (_listModel.displayName.length != 0) {
        self.nameLabel.text = _listModel.displayName;
    }else{
        self.nameLabel.text = _listModel.nickname;
    }
    NSString *  str = [ImageUrl changeUrl:_listModel.userPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
}
@end
