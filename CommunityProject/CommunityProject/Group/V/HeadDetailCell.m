//
//  HeadDetailCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HeadDetailCell.h"

@implementation HeadDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 30;
}
-(void)setUserModel:(JoinUserModel *)userModel{
    _userModel = userModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_userModel.userPortraitUrl]]]];
}
@end
