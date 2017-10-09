
//
//  MyHelpAndAnswerCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyHelpAndAnswerCell.h"

@implementation MyHelpAndAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHelpModel:(MyHelpListModel *)helpModel{
    _helpModel = helpModel;
    self.timeLabel.text = _helpModel.time;
    self.titleLabel.text = _helpModel.title;
    self.contentLabel.text = _helpModel.content;
    self.answerLabel.text = [NSString stringWithFormat:@"回答 %@",_helpModel.answers];
    self.contriLabel.text = [NSString stringWithFormat:@"贡献币 %@",_helpModel.contributionCoin];
}
@end
