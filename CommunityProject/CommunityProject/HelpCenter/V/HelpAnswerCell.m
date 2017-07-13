//
//  HelpAnswerCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HelpAnswerCell.h"
#define CommentZanURL @"appapi/app/commentLikes"
#import "HelpCommentController.h"

@implementation HelpAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusRoundingRect];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//评论点赞--后台没做
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    UIButton * button = (UIButton *)sender;
    HelpAnswerCell * cell = (HelpAnswerCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    HelpAnswerListModel * help = self.dataArr[indexPath.row];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSDictionary * dict = @{@"userId":userId,@"commentId":help.idStr,@"status":self.loveBtn.selected?@"1":@"0"};
    NSSLog(@"%@",dict);
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
//评论
- (IBAction)commentClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    HelpAnswerCell * cell = (HelpAnswerCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Help" bundle:nil];
    HelpCommentController * help = [sb instantiateViewControllerWithIdentifier:@"HelpCommentController"];
    HelpAnswerListModel * model = self.dataArr[indexPath.row];
    help.actiId = self.iDStr;
    help.titleStr = self.titleStr;
    help.time = model.time;
    help.comment = model.content;
    help.loveCount = [NSString stringWithFormat:@"%@",model.likes];
    help.nameStr = model.nickname;
    help.headUrl = model.userPortraitUrl;
    help.hostId = self.hostId;
    help.answerId = model.idStr;
    self.block(help);
 
}
-(void)setHelpModel:(HelpAnswerListModel *)helpModel{
    _helpModel = helpModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_helpModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.timeLabel.text = _helpModel.time;
    self.contentLabel.text = _helpModel.content;
    self.nameLabel.text = _helpModel.nickname;
    self.likes = [NSString stringWithFormat:@"%@",_helpModel.likes];
    [self.loveBtn setTitle:self.likes forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",_helpModel.commentNumber] forState:UIControlStateNormal];
    if ([_helpModel.likesStatus isEqualToString:@"0"]) {
        self.loveBtn.selected = NO;
    }else{
        self.loveBtn.selected = YES;
    }

}
@end
