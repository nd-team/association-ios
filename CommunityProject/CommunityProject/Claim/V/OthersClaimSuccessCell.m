//
//  OthersClaimSuccessCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "OthersClaimSuccessCell.h"

@implementation OthersClaimSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOtherModel:(OthersClaimModel *)otherModel{
    _otherModel = otherModel;
    NSString * str = [ImageUrl changeUrl:_otherModel.userPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    self.nameLabel.attributedText = [ImageUrl changeTextColor:[NSString stringWithFormat:@"%@ 成功认领您",_otherModel.nickname] andFirstRangeStr:_otherModel.nickname andFirstChangeColor:UIColorFromRGB(0x121212) andSecondRangeStr:@" 成功认领您" andSecondColor:UIColorFromRGB(0x999999)];
    self.timeLabel.text = [_otherModel.claimTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}
@end
