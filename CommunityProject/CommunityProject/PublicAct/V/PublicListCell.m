//
//  PublicListCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PublicListCell.h"
#import "PlatformCommentController.h"

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
//公益文章点赞
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    UIButton * button = (UIButton *)sender;
    PublicListCell * cell = (PublicListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    PublicListModel * model = self.dataArr[indexPath.row];
    NSDictionary * dic = @{@"userId":userId,@"articleId":[NSString stringWithFormat:@"%ld",(long)model.id],@"type":@"7",@"status":self.loveBtn.selected?@"1":@"0"};
    self.zanBlock(dic,indexPath,self.loveBtn.selected);
    
}
//评论
- (IBAction)judgeClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    PublicListCell * cell = (PublicListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    PublicListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
    PlatformCommentController * comment = [sb instantiateViewControllerWithIdentifier:@"PlatformCommentController"];
    comment.idStr = [NSString stringWithFormat:@"%ld",model.id];
    comment.type = 7;
    comment.headUrl = model.userPortraitUrl;
    comment.content = model.title;
    self.block(comment);
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
    [self.loveBtn setTitle:_publicModel.likes forState:UIControlStateNormal];
    [self.commentBtn setTitle:_publicModel.commentNumber forState:UIControlStateNormal];
    
}

@end
