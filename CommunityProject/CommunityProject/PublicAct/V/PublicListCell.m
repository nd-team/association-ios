//
//  PublicListCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PublicListCell.h"

@implementation PublicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart.png"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//分享
- (IBAction)shareClick:(id)sender {
    
}
//点赞
- (IBAction)loveClick:(id)sender {
    
    
}
//评论
- (IBAction)judgeClick:(id)sender {
    
}

-(void)setPublicModel:(PublicListModel *)publicModel{
    _publicModel = publicModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_publicModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = _publicModel.nickname;
    [self.topicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_publicModel.activesImage]]] placeholderImage:[UIImage imageNamed:@"banner3"]];

    self.titleLabel.text = _publicModel.title;
    self.contentLabel.text = _publicModel.content;
    self.areaLabel.text = _publicModel.address;
    if ([_publicModel.status isEqualToString:@"1"]) {
        self.statusLabel.text = @"进行中";
        
    }else if([_publicModel.status isEqualToString:@"0"]){
        self.statusLabel.text = @"已结束";
    }else{
        self.statusLabel.text = @"未开始";
    }
}

@end
