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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)judgeClick:(id)sender {
    //评论
    
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
    cell.answerModel = _commentModel.replyUsers[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _commentModel.replyUsers.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //回复评论
    
}

@end
