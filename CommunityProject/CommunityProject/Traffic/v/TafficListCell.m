//
//  TafficListCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/6.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TafficListCell.h"
#import "PlatformCommentController.h"

#define ZanURL @"appapi/app/userPraise"

@implementation TafficListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}
//分享
- (IBAction)shareClick:(id)sender {
    //block回调
    UIButton * button = (UIButton *)sender;
    TafficListCell * cell = (TafficListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (self.isTraffic) {
        TafficeListModel * model = self.dataArr[indexPath.row];
        self.share(model.image, model.title, model.idStr);
   
    }else{
        GoodsListModel * model = self.dataArr[indexPath.row];
        self.share(model.image, model.title, model.idStr);
    }
    
}
//文章点赞
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    UIButton * button = (UIButton *)sender;
    TafficListCell * cell = (TafficListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSString * userId  = [DEFAULTS objectForKey:@"userId"];

    if (self.isTraffic) {
        TafficeListModel * model = self.dataArr[indexPath.row];
        NSDictionary * params = @{@"userId":userId,@"articleId":model.idStr,@"type":@"5",@"status":self.loveBtn.selected?@"1":@"0"};
        [self love:params];
    }else{
        GoodsListModel * model = self.dataArr[indexPath.row];
        NSDictionary * params = @{@"userId":userId,@"articleId":model.idStr,@"type":@"3",@"status":self.loveBtn.selected?@"1":@"0"};
        [self love:params];
    }
    
   
}
-(void)love:(NSDictionary *)params{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"灵感贩卖点赞失败：%@",error);
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
                
            }else{
                weakSelf.loveBtn.selected = NO;
            }
        }
        
    }];
}
//评论
- (IBAction)commentClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    TafficListCell * cell = (TafficListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
    PlatformCommentController * comment = [sb instantiateViewControllerWithIdentifier:@"PlatformCommentController"];
    if (self.isTraffic) {
        TafficeListModel * model = self.dataArr[indexPath.row];
        comment.idStr = model.idStr;
        comment.type = 5;
        comment.headUrl = model.userPortraitUrl;
        comment.content = model.title;
    }else{
        GoodsListModel * model = self.dataArr[indexPath.row];
        comment.idStr = model.idStr;
        comment.type = 3;
        comment.headUrl = model.userPortraitUrl;
        comment.content = model.title;
    }
    self.block(comment);
    
}
-(void)setListModel:(TafficeListModel *)listModel{
    _listModel = listModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_listModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = _listModel.nickname;
    [self.uploadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_listModel.image]]] placeholderImage:[UIImage imageNamed:@"banner3"]];
    
    self.titleLabel.text = _listModel.title;
    self.contentLabel.text = _listModel.content;
    [self.loveBtn setTitle:[NSString stringWithFormat:@"%@",_listModel.likes] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",_listModel.commentNumber] forState:UIControlStateNormal];
    [self.shareBtn setTitle:[NSString stringWithFormat:@"%@",_listModel.shareNumber] forState:UIControlStateNormal];
    self.likes = [NSString stringWithFormat:@"%@",_listModel.likes];

    
}
-(void)setGoodsModel:(GoodsListModel *)goodsModel{
    _goodsModel = goodsModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_goodsModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = _goodsModel.nickname;
    [self.uploadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_goodsModel.image]]] placeholderImage:[UIImage imageNamed:@"banner3"]];
    
    self.titleLabel.text = _goodsModel.title;
    self.contentLabel.text = _goodsModel.synopsis;
    [self.loveBtn setTitle:[NSString stringWithFormat:@"%@",_goodsModel.likes] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",_goodsModel.commentNumber] forState:UIControlStateNormal];
    [self.shareBtn setTitle:[NSString stringWithFormat:@"%@",_goodsModel.shareNumber] forState:UIControlStateNormal];
    self.likes = [NSString stringWithFormat:@"%@",_goodsModel.likes];

}
@end
