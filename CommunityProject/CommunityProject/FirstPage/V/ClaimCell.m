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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setClaimModel:(ClaimModel *)claimModel{
    _claimModel = claimModel;
    NSString * str = [ImageUrl changeUrl:_claimModel.userPortraitUrl];

//    if ([_claimModel.userPortraitUrl containsString:@"\\"]) {
//        str = [_claimModel.userPortraitUrl stringByReplacingCharactersInRange:[_claimModel.userPortraitUrl rangeOfString:@"\\"] withString:@"/"];
//    }else{
//        str = _claimModel.userPortraitUrl;
//    }
    NSString * encodeUrl = [NSString stringWithFormat:@"http://192.168.0.209:90%@",str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    self.nicknameLabel.text = [NSString stringWithFormat:@"昵    称:%@",_claimModel.nickname];
    self.numberLabel.text = [NSString stringWithFormat:@"编    号:%@",_claimModel.numberId];
    if ([_claimModel.claimFullName isKindOfClass:[NSNull class]]) {
        self.recomendPersonLabel.text = [NSString stringWithFormat:@"推 荐 人:%@  %@",_claimModel.claimNumberId,_claimModel.claimNickName];
    }else{
        self.recomendPersonLabel.text = [NSString stringWithFormat:@"推 荐 人:%@  %@",_claimModel.claimNumberId,_claimModel.claimFullName];
    }
    self.nameLabel.text = [NSString stringWithFormat:@"姓    名:%@",_claimModel.fullName];

}

- (IBAction)calimClick:(id)sender {
    
    
}

@end
