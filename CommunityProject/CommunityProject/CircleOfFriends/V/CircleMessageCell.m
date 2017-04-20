//
//  CircleMessageCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleMessageCell.h"

@implementation CircleMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setMessageModel:(CircleUnreadMessageModel *)messageModel{
    _messageModel = messageModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_messageModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = _messageModel.nickname;
    self.contentLabel.text = _messageModel.content;
    [self.rightImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_messageModel.articleImages]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.timeLabel.text = _messageModel.commentTime;
    
}
@end
