//
//  VoteListCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VoteListCell.h"
#import "VoteDetailController.h"

@implementation VoteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}
- (IBAction)voteClick:(id)sender {
    self.voteBtn.selected = !self.voteBtn.selected;
    UIButton * button = (UIButton *)sender;
    VoteListCell * cell = (VoteListCell *)[[[button superview]superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    VoteListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    VoteDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"VoteDetailController"];
    detail.groupID = self.groupID;
    detail.voteID = model.voteId;
    detail.createTime = model.addTime;
    int timeStatus = [model.timeStatus intValue];
    int status = [model.status intValue];
    if (timeStatus == 0) {
        //活动已结束
        detail.statusStr = @"活动结束";
    }else{
        //进行中
        detail.statusStr = @"进行中";
    }
    if (status == 0) {
        detail.isVote = NO;
    }else{
        detail.isVote = YES;
    }
    detail.topic = model.voteTitle;
    detail.topicUrl = model.voteImage;
    detail.endTime = model.endTime;
    detail.delegate = self.listVC;
    self.block(detail);
 
    
}
-(void)setVoteModel:(VoteListModel *)voteModel{
    _voteModel = voteModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_voteModel.voteImage]]]];
    self.titleLabel.text = _voteModel.voteTitle;
    NSArray * option = _voteModel.option;
    int i = 0;
    for (OptionModel * model in option) {
        switch (i) {
            case 0:
                self.chooseOneLabel.text = model.content;

                break;
               case 1:
                self.chooseTwoLabel.text = model.content;
                break;
            default:
                self.chooseThreeLabel.text = model.content;
                break;
        }
        i++;
    }
    int timeStatus = [_voteModel.timeStatus intValue];
    int status = [_voteModel.status intValue];
    if (timeStatus == 0) {
        //活动已结束
        self.buttonWidthCons.constant = 116;
        [self setButtonTitle:@"投票截止，看结果" andImage:@"voteStop" andTextColor:UIColorFromRGB(0x666666)];
    }else if (timeStatus == 1 && status == 0){
        //未投票
        self.buttonWidthCons.constant = 84;
        [self setButtonTitle:@"立即投票" andImage:@"voteBtn" andTextColor:UIColorFromRGB(0x444343)];
    }else if (timeStatus == 1 && status == 1){
        //已投票
        self.buttonWidthCons.constant = 104;
        [self setButtonTitle:@"已投票，看结果" andImage:@"voteResult" andTextColor:UIColorFromRGB(0xfefefe)];

    }
}
-(void)setButtonTitle:(NSString *)title andImage:(NSString *)imgName andTextColor:(UIColor*)color{
    [self.voteBtn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [self.voteBtn setTitle:title forState:UIControlStateNormal];
    [self.voteBtn setTitleColor:color forState:UIControlStateNormal];
}
@end
