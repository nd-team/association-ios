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
    
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_searchModel.userPortraitUrl]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl] placeholderImage:[UIImage imageNamed:@"Carial.jpg"]];

    self.nameLabel.text = _searchModel.nickname;
}
@end
