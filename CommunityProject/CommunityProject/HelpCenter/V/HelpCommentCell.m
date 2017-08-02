//
//  HelpCommentCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/5.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HelpCommentCell.h"
#define CommentZanURL @"appapi/app/commentLikes"

@implementation HelpCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusRoundingRect];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//评论的评论点赞
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    UIButton * button = (UIButton *)sender;
    HelpCommentCell * cell = (HelpCommentCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    CommentDetailListModel * help = self.dataArr[indexPath.row];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSDictionary * dict = @{@"userId":userId,@"commentId":help.idStr,@"status":self.loveBtn.selected?@"1":@"0"};
//    NSSLog(@"%@",dict);
    [self zanComment:dict];
}
-(void)zanComment:(NSDictionary *)dict{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CommentZanURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"评论点赞失败：%@",error);
            weakSelf.loveBtn.selected = NO;
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                if (self.loveBtn.selected) {
                    self.likes = [NSString stringWithFormat:@"%zi",[self.likes integerValue]+1];
                }else{
                    self.likes = [NSString stringWithFormat:@"%zi",[self.likes integerValue]-1];
                }
                [weakSelf.loveBtn setTitle:self.likes forState:UIControlStateNormal];
                
            }else if ([code intValue] == 1029){
                weakSelf.loveBtn.selected = NO;
            }else if ([code intValue] == 1030){
                weakSelf.loveBtn.selected = NO;
            }else{
                weakSelf.loveBtn.selected = NO;
            }
        }
        
    }];
}

-(void)setCommentModel:(CommentDetailListModel *)commentModel{
    _commentModel = commentModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_commentModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.timeLabel.text = _commentModel.commentTime;
    self.contentLabel.text = _commentModel.content;
    self.nameLabel.text = _commentModel.nickname;
    self.likes = [NSString stringWithFormat:@"%@",_commentModel.likes];
    [self.loveBtn setTitle:self.likes forState:UIControlStateNormal];
    if ([_commentModel.likesStatus isEqualToString:@"0"]) {
        self.loveBtn.selected = NO;
    }else{
        self.loveBtn.selected = YES;
    }
}
@end
