//
//  ClaimCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/16.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ClaimCell.h"

@implementation ClaimCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    //
    self.claimBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setClaimModel:(ClaimModel *)claimModel{
    _claimModel = claimModel;
    NSString * str = [ImageUrl changeUrl:_claimModel.userPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    self.nicknameLabel.text = [NSString stringWithFormat:@"昵    称：%@",_claimModel.nickname];
    self.numberLabel.text = [NSString stringWithFormat:@"编    号：%@",_claimModel.recommendId];
    self.recomendPersonLabel.text = [NSString stringWithFormat:@"推 荐 人：%@  %@",_claimModel.claimUsersId,_claimModel.claimUsersName];
    if ([_claimModel.fullName isKindOfClass:[NSNull class]]) {
        self.nameLabel.text = @"";
 
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"姓    名：%@",_claimModel.fullName];
  
    }
}

- (IBAction)calimClick:(id)sender {
    
    
}

@end
