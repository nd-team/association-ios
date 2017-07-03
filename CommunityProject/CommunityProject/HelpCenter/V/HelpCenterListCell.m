
//
//  HelpCenterListCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HelpCenterListCell.h"

@implementation HelpCenterListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusRoundingRect];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setListModel:(HelpListModel *)listModel{
    _listModel = listModel;
    self.nameLabel.text = _listModel.nickname;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_listModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.timeLabel.text = _listModel.time;
    self.titleLabel.text = _listModel.title;
    self.contentLabel.text = _listModel.content;
    self.answerLabel.text = [NSString stringWithFormat:@"回答 %@",_listModel.helpNumber];
    self.contributeLabel.text = [NSString stringWithFormat:@"贡献币 %@",_listModel.contributionCoin];
    

}
@end
