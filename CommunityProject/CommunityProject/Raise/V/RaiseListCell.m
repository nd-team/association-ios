//
//  RaiseListCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "RaiseListCell.h"
#import "PlatformCommentController.h"
#define ZanURL @"appapi/app/userPraise"

@implementation RaiseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//分享
- (IBAction)shareClick:(id)sender {
    //block回调
    UIButton * button = (UIButton *)sender;
    RaiseListCell * cell = (RaiseListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    RaiseListModel * model = self.dataArr[indexPath.row];
    self.block(model.image, model.title, model.idStr);
    
}
//点赞
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    UIButton * button = (UIButton *)sender;
    RaiseListCell * cell = (RaiseListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSString * userId  = [DEFAULTS objectForKey:@"userId"];
    RaiseListModel * model = self.dataArr[indexPath.row];
    NSDictionary * params = @{@"userId":userId,@"articleId":model.idStr,@"type":@"1",@"status":self.loveBtn.selected?@"1":@"0"};
    [self love:params];
    
}
-(void)love:(NSDictionary *)params{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"众筹点赞失败：%@",error);
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
                
            }else{
                weakSelf.loveBtn.selected = NO;
            }
        }
        
    }];
}

//评论
- (IBAction)commentClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    RaiseListCell * cell = (RaiseListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
    PlatformCommentController * comment = [sb instantiateViewControllerWithIdentifier:@"PlatformCommentController"];
   
    RaiseListModel * model = self.dataArr[indexPath.row];
    comment.idStr = model.idStr;
    comment.type = 1;
    comment.headUrl = model.userPortraitUrl;
    comment.content = model.title;
    self.push(comment);
}
-(void)setRaiseModel:(RaiseListModel *)raiseModel{
    _raiseModel = raiseModel;
    self.titleLabel.text = _raiseModel.title;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_raiseModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ · 发起人",_raiseModel.nickname];
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_raiseModel.image]]] placeholderImage:[UIImage imageNamed:@"banner"]];
    self.contentLabel.text = _raiseModel.objective;
    self.alreadyMoneyLabel.text = [NSString stringWithFormat:@"认筹金额：¥%@",_raiseModel.contribution];
    self.allMoneyLabel.text = [NSString stringWithFormat:@"目标金额：¥%@",_raiseModel.capital];
    self.progressLabel.text = [NSString stringWithFormat:@"%@%%",_raiseModel.percent];
    self.progressView.progress = [_raiseModel.percent integerValue]/100;
    self.dayLabel.text = [NSString stringWithFormat:@"剩余%@天",_raiseModel.days];
    [self.loveBtn setTitle:[NSString stringWithFormat:@"%@",_raiseModel.likes] forState:UIControlStateNormal];
    [self.shareBtn setTitle:[NSString stringWithFormat:@"%@",_raiseModel.shareNumber] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",_raiseModel.commentNumber] forState:UIControlStateNormal];
    if ([_raiseModel.type isEqualToString:@"1"]) {
        self.typeLabel.text = @"产品众筹";
    }else{
        self.typeLabel.text = @"求助众筹";
    }
    self.likes = [NSString stringWithFormat:@"%@",_raiseModel.likes];

}
@end
