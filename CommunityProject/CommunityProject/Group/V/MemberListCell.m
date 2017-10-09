//
//  MemberListCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MemberListCell.h"

@implementation MemberListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setListModel:(MemberListModel *)listModel{
    _listModel = listModel;
    self.nameLabel.text = _listModel.userName;
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_listModel.userPortraitUrl]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
}
-(void)setUserModel:(JoinUserModel *)userModel{
    _userModel = userModel;
    self.nameLabel.text = _userModel.nickname;
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_userModel.userPortraitUrl]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
}
@end
