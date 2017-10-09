//
//  AddressCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/21.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setListModel:(FriendsListModel *)listModel{
    _listModel = listModel;
    if (_listModel.userId.length != 0) {
        NSString * str = [ImageUrl changeUrl:_listModel.userPortraitUrl];
        NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
        NSString * userId = [DEFAULTS objectForKey:@"userId"];
        if ([userId isEqualToString:_listModel.userId]) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_listModel.userPortraitUrl] placeholderImage:[UIImage imageNamed:@"default.png"]];
            
        }else{
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl] placeholderImage:[UIImage imageNamed:@"default.png"]];
            
        }
    }else{
        //通讯录默认头像
        self.headImageView.image = [UIImage imageNamed:@"default.png"];
    }
    if (_listModel.displayName.length != 0) {
        self.nameLabel.text = _listModel.displayName;
    }else{
        self.nameLabel.text = _listModel.nickname;
    }

}
@end
