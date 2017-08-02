//
//  ClaimCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/16.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ClaimCell.h"
#import "ClaimInfoController.h"

@implementation ClaimCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setClaimModel:(ClaimModel *)claimModel{
    _claimModel = claimModel;
    NSString * str = [ImageUrl changeUrl:_claimModel.userPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nicknameLabel.text = [NSString stringWithFormat:@"昵    称：%@",_claimModel.nickname];
    self.numberLabel.text = [NSString stringWithFormat:@"编    号：%@",_claimModel.recommendId];
    self.recomendPersonLabel.text = [NSString stringWithFormat:@"推 荐 人：%@  %@",_claimModel.claimUsersId,_claimModel.claimUsersName];
    if (_claimModel.fullName.length == 0) {
        self.nameLabel.text = @"";
        self.nicknameTopCons.constant = 25;
        self.nameHeightCons.constant = 0 ;
        self.nameTopCons.constant = 0;
 
    }else{
        self.nicknameTopCons.constant = 15;
        self.nameHeightCons.constant = 15;
        self.nameTopCons.constant = 10;
        self.nameLabel.text = [NSString stringWithFormat:@"姓    名：%@",_claimModel.fullName];
    }
}

- (IBAction)calimClick:(id)sender {
    //如果不是VIP提示用户
    NSInteger  vip = [DEFAULTS integerForKey:@"checkVip"];
    if (vip == 1) {
        UIButton * button = (UIButton *)sender;
        ClaimCell * cell = (ClaimCell *)[[button superview]superview];
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        ClaimModel * model = self.dataArr[indexPath.row];
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ClaimCenter" bundle:nil];
        ClaimInfoController * info = [sb instantiateViewControllerWithIdentifier:@"ClaimInfoController"];
        info.claimUserId = model.userId;
        info.url = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:model.userPortraitUrl]];
        if (model.fullName.length !=0) {
            info.name = model.fullName;
        }else{
            info.name = model.nickname;
        }
        
        self.block(info);

    }else{
        
    }
}

@end
