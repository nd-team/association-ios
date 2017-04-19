//
//  CircleCommentCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleCommentCell.h"
#import "AnswerCommentCell.h"

@implementation CircleCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 15;
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerCommentCell" bundle:nil] forCellReuseIdentifier:@"AnswerCommentCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 27;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)judgeClick:(id)sender {
    //回复评论
    UIButton * button = (UIButton *)sender;
    CircleCommentCell * cell = (CircleCommentCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    CircleCommentModel * model = self.baseArr[indexPath.row];
    self.block([NSString stringWithFormat:@"%ld",model.id],model.nickname);

}
-(void)setCommentModel:(CircleCommentModel *)commentModel{
    _commentModel = commentModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_commentModel.userPortraitUrl]]]];
    self.nameLabel.text = _commentModel.nickname;
    self.contentLabel.text = _commentModel.content;
    self.timeLabel.text = _commentModel.commentTime;
    [self.tableView reloadData];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCommentCell"];
    cell.answerModel = self.commentModel.replyUsers[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentModel.replyUsers.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //回复评论
    CircleAnswerModel * model = self.commentModel.replyUsers[indexPath.row];
    self.block([NSString stringWithFormat:@"%ld",model.id],model.nickname);
}

@end
