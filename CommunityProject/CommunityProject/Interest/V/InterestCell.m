//
//  InterestCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "InterestCell.h"
#import "AddFriendController.h"

@implementation InterestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)appliClick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    InterestCell * cell = (InterestCell *)[[btn superview]superview];
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    InterestModel * model = self.dataArr[index.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    AddFriendController * add = [sb instantiateViewControllerWithIdentifier:@"AddFriendController"];
    add.buttonName = @"申请加群";
    add.groupId = model.groupId;
    self.block(add);

}
-(void)setInterestModel:(InterestModel *)interestModel{
    _interestModel = interestModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_interestModel.groupPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = _interestModel.groupName;
    self.peopleLabel.text = [NSString stringWithFormat:@"群人数：%@人",_interestModel.groupUserNumber];
}
@end
