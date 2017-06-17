//
//  AllMessageCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AllMessageCell.h"

@implementation AllMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(AllMessageModel *)model{
    _model = model;
     [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_model.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default.png"]];
     self.contentLabel.attributedText = [ImageUrl messageTextColor:[NSString stringWithFormat:@"%@评论了您的”%@“",_model.nickname,_model.content] andFirstString:_model.nickname andFirstColor:UIColorFromRGB(0x121212) andFirstFont:[UIFont systemFontOfSize:15] andSecondStr:@"评论了您的" andSecondColor:UIColorFromRGB(0xb5b5b5) andSecondFont:[UIFont systemFontOfSize:15] andThirdStr:[NSString stringWithFormat:@"”%@“",_model.content] andThirdColor:UIColorFromRGB(0x333333) andThirdFont:[UIFont systemFontOfSize:15]];
    self.timeLabel.text = [_model.commentTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
}
@end
