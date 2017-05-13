//
//  MyClaimCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyClaimCell.h"

@implementation MyClaimCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setClaimModel:(ClaimCenterModel *)claimModel{
    _claimModel = claimModel;
    NSString * str = [ImageUrl changeUrl:_claimModel.userPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    if (_claimModel.fullName.length != 0) {
        self.nameLabel.text = _claimModel.fullName;
    }else{
        self.nameLabel.text = _claimModel.nickname;
    }
    NSString * time = [_claimModel.claimTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.timeLabel.text = time;

}
@end
