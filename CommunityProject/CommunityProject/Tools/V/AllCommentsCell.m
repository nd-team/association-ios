//
//  AllCommentsCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AllCommentsCell.h"

@implementation AllCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusRoundingRect];
    [self.zanBtn setImage:[UIImage imageNamed:@"unlike.png"] forState:UIControlStateNormal];
    [self.zanBtn setImage:[UIImage imageNamed:@"yellowZan.png"] forState:UIControlStateSelected];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (IBAction)zanClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    self.zanBtn.selected = !self.zanBtn.selected;
    AllCommentsCell * cell = (AllCommentsCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    CommentsListModel * model = self.dataArr[indexPath.row];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];

    NSDictionary * dict = @{@"userId":userId,@"commentId":[NSString stringWithFormat:@"%ld",(long)model.id],@"status":self.zanBtn.selected?@"1":@"0"};
    self.block(dict,indexPath,self.zanBtn.selected);
}
-(void)setCommentModel:(CommentsListModel *)commentModel{
    _commentModel = commentModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_commentModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default.png"]];
    self.nameLabel.text = _commentModel.nickname;
    self.commentLabel.text = _commentModel.content;
    [self.zanBtn setTitle:_commentModel.likes forState:UIControlStateNormal];
    self.timeLabel.text = [_commentModel.commentTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSInteger  likeStatus = [_commentModel.likesStatus integerValue];
    if (likeStatus == 0) {
        self.zanBtn.selected = NO;
    }else{
        self.zanBtn.selected = YES;
    }

}
@end
