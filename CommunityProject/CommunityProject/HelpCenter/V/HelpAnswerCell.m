//
//  HelpAnswerCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HelpAnswerCell.h"
#define CommentZanURL @"appapi/app/commentLikes"

@implementation HelpAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusRoundingRect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//评论点赞
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    UIButton * button = (UIButton *)sender;
    HelpAnswerCell * cell = (HelpAnswerCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    HelpAnswerListModel * help = self.dataArr[indexPath.row];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSDictionary * dict = @{@"userId":userId,@"commentId":help.idStr,@"status":self.loveBtn.selected?@"1":@"0"};
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
                    self.likes = [NSString stringWithFormat:@"%ld",[self.likes integerValue]+1];
                }else{
                    self.likes = [NSString stringWithFormat:@"%ld",[self.likes integerValue]-1];
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

}
@end
