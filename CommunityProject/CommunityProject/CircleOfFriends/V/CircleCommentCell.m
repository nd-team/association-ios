
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 22;
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
    self.block([NSString stringWithFormat:@"%ld",model.id],model.nickname);

}
-(void)setCommentModel:(CircleCommentModel *)commentModel{
    _commentModel = commentModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_commentModel.userPortraitUrl]]]];
    self.nameLabel.text = _commentModel.nickname;
    self.contentLabel.text = _commentModel.content;
    self.timeLabel.text = _commentModel.commentTime;
       //判断一级文字
    //取到label的高度
    CGSize size = [self sizeWithString:self.contentLabel.text andWidth:KMainScreenWidth-45 andFont:13];
    self.conHeightCons.constant = size.height;
//    NSSLog(@"%f===",size.height);
    if (_commentModel.replyUsers.count == 0) {
//        self.tbHeightCons.constant = 0;
        _commentModel.height = 75+size.height;
        //改变frame
        CGRect rect = self.tableView.frame;
        rect.size.height = 0;
        self.tableView.frame = rect;
        [self.tableView layoutIfNeeded];
        NSSLog(@"---%f",self.tableView.frame.size.height);
    }else {
//        self.tbHeightCons.constant = 22;
//        for (CircleAnswerModel * model in _commentModel.replyUsers) {
//            NSSLog(@"%f",model.height);
//            if (model.height != 0) {
//                self.tbHeightCons.constant += model.height;
//                NSSLog(@"%f-",self.tbHeightCons.constant);
//
//            }
//        }
//        //改变frame
//        CGRect rect = self.tableView.frame;
//        rect.size.height = self.tbHeightCons.constant;
//        self.tableView.frame = rect;
        NSSLog(@"%f",self.tableView.frame.size.height);
        _commentModel.height = 90+size.height+self.tableView.frame.size.height;
//        [self.tableView layoutIfNeeded];
    }
    [self.tableView reloadData];
    [self layoutIfNeeded];

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
        return model.height;

    }

    return 22;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCommentCell"];
    cell.answerModel = self.commentModel.replyUsers[indexPath.row];
    return cell;
}
-(CGSize)sizeWithString:(NSString *)str andWidth:(CGFloat)width andFont:(CGFloat)font{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentModel.replyUsers.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //回复评论
    CircleAnswerModel * model = self.commentModel.replyUsers[indexPath.row];
    self.block([NSString stringWithFormat:@"%ld",model.id],model.nickname);
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UITableView class]]) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}
@end
