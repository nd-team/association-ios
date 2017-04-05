//
//  ChooseCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/31.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChooseCell.h"

@implementation ChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateNormal];
    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"selBtn"] forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chooseClick:(id)sender {
    self.chooseBtn.selected = !self.chooseBtn.selected;
    UIButton * button = (UIButton *)sender;
    ChooseCell * cell = (ChooseCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    MemberListModel * model = self.dataArr[indexPath.section][indexPath.row];
    if (self.isSingle == 1) {
        if (self.chooseBtn.selected) {
            self.managerBlock(model.userId,YES);
            self.selectBlock(indexPath);
        }
    }
    
}
-(void)setMemberModel:(MemberListModel *)memberModel{
    _memberModel = memberModel;
    self.nameLabel.text = _memberModel.userName;
    NSString *  str = [ImageUrl changeUrl:_memberModel.userPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];

}
@end
