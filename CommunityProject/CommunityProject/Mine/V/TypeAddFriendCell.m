//
//  TypeAddFriendCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TypeAddFriendCell.h"

@implementation TypeAddFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addFriendClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    TypeAddFriendCell * cell = (TypeAddFriendCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    MyPeopleListModel * model = self.dataArr[indexPath.row];
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RecommendAddFriend" object:model.userId];
}
-(void)setListModel:(MyPeopleListModel *)listModel{
    _listModel = listModel;
    self.nicknameLabel.text = [NSString stringWithFormat:@"昵称：%@",_listModel.nickname];
    self.userLabel.text = [NSString stringWithFormat:@"账号：%@",_listModel.userId];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_listModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    if ([_listModel.status isEqualToString:@"0"]) {
        self.addBtn.hidden = NO;
    }else{
        self.addBtn.hidden = YES;
 
    }
    if ([_listModel.sex isEqualToString:@"1"]) {
        self.sexImage.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sexImage.image = [UIImage imageNamed:@"woman.png"];
    }
    self.recomendLabel.text = [NSString stringWithFormat:@"推荐人：%@",_listModel.recommendUser];
}
@end
