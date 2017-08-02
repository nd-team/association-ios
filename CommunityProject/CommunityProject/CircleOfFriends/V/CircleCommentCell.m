
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
    [self.headImageView zy_cornerRadiusRoundingRect];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerCommentCell" bundle:nil] forCellReuseIdentifier:@"AnswerCommentCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 22;
//    self.tableView.layer.borderWidth = 1;
//    self.tableView.layer.borderColor = [UIColor orangeColor].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)judgeClick:(id)sender {
    //回复评论
    UIButton * button = (UIButton *)sender;
    CircleCommentCell * cell = (CircleCommentCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tbView indexPathForCell:cell];
    CircleCommentModel * model = self.baseArr[indexPath.row];
    self.block([NSString stringWithFormat:@"%ld",(long)model.id],model.nickname);

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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleAnswerModel * model =self.commentModel.replyUsers[indexPath.row];
    if (model.height != 0) {
        if (indexPath.row == 0 || indexPath.row == self.commentModel.replyUsers.count-1) {
            model.height = model.height+15;
        }else{
            model.height = model.height+10;
        }
//        NSSLog(@"%f==",model.height);
        return model.height;

    }

    return 22;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCommentCell"];
    //一行数据
    if (self.commentModel.replyUsers.count-1 == 0) {
        cell.conHeightCons.constant = 0;
        cell.bottomCons.constant = 10;
    }else {
        //多行
        if (indexPath.row == 0) {
            cell.conHeightCons.constant = 0;
            cell.bottomCons.constant = 0;
        }else if (indexPath.row == self.commentModel.replyUsers.count-1){
            cell.conHeightCons.constant = 0;
            cell.bottomCons.constant = 5;
        }else{
            cell.conHeightCons.constant = 0;
            cell.bottomCons.constant = 3;
        }
    }
    cell.answerModel = self.commentModel.replyUsers[indexPath.row];
    return cell;
}
//-(CGSize)sizeWithString:(NSString *)str andWidth:(CGFloat)width andFont:(CGFloat)font{
//    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
//    return rect.size;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentModel.replyUsers.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //回复评论
    CircleAnswerModel * model = self.commentModel.replyUsers[indexPath.row];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    //左侧是当前用户点击之后仍然是回复右边的人
    if ([model.userId isEqualToString:userId]) {
        self.block(model.fromId,model.fromNickname);
    }else{
        self.block([NSString stringWithFormat:@"%ld",(long)model.id],model.nickname);
  
    }
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UITableView class]]) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}
@end
