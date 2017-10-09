//
//  MeClaimSuccessCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MeClaimSuccessCell.h"

@implementation MeClaimSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOtherModel:(OthersClaimModel *)otherModel{
    _otherModel = otherModel;
    self.contentLabel.attributedText = [ImageUrl changeTextColor:[NSString stringWithFormat:@"恭喜你！成功认领了 %@",_otherModel.nickname] andFirstRangeStr:@"恭喜你！成功认领了 " andFirstChangeColor:UIColorFromRGB(0xe64242) andSecondRangeStr:_otherModel.nickname andSecondColor:UIColorFromRGB(0x121212)];
    self.timeLabel.text = [_otherModel.claimTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

@end
