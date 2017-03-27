//
//  AddFriendCell.m
//  LoveChatProject
//
//  Created by bjike on 17/1/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AddFriendCell.h"

@implementation AddFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSearchModel:(SearchFriendModel *)searchModel{
    _searchModel = searchModel;
    NSString * str = nil;
    if ([_searchModel.userPortraitUrl containsString:@"\\"]) {
        str = [_searchModel.userPortraitUrl stringByReplacingCharactersInRange:[_searchModel.userPortraitUrl rangeOfString:@"\\"] withString:@"/"];
    }else{
        str = _searchModel.userPortraitUrl;
    }
    NSString * encodeUrl = [NSString stringWithFormat:@"http://192.168.0.212%@",str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl] placeholderImage:[UIImage imageNamed:@"Carial.jpg"]];

    self.nameLabel.text = _searchModel.nickname;
}
@end
