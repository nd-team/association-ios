//
//  ClaimCenterCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/11.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ClaimCenterCell.h"

@implementation ClaimCenterCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 10;
   
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headImageView.bounds byRoundingCorners:UIRectCornerTopLeft |UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.headImageView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headImageView.layer.mask = maskLayer;
    
}
-(void)setCenterModel:(ClaimCenterModel *)centerModel{
    _centerModel = centerModel;
    NSString * str = [ImageUrl changeUrl:_centerModel.userPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    if (_centerModel.fullName.length != 0) {
        self.nameLabel.text = _centerModel.fullName;
    }else{
        self.nameLabel.text = _centerModel.nickname;
    }

}
@end
