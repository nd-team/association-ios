//
//  SearchGroupCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/27.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SearchGroupCell.h"
#import "AddFriendController.h"

@implementation SearchGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setGroupModel:(SearchGroupModel *)groupModel{
    _groupModel = groupModel;
    NSString * encodeUrl = [NSString stringWithFormat:@"http://192.168.0.209:90/%@",[ImageUrl changeUrl:_groupModel.groupPortraitUrl]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl] placeholderImage:[UIImage imageNamed:@"Carial.jpg"]];
    
    self.nameLabel.text = _groupModel.groupName;
    self.peopleLabel.text = [NSString stringWithFormat:@"群人数：%@",_groupModel.groupUserNumber];

}
- (IBAction)appClick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    SearchGroupCell * searchCell = (SearchGroupCell *)[[btn superview]superview];
    NSIndexPath * index = [self.tableView indexPathForCell:searchCell];
    SearchGroupModel * search = self.dataArr[index.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    AddFriendController * add = [sb instantiateViewControllerWithIdentifier:@"AddFriendController"];
    add.buttonName = @"申请加群";
    add.groupId = search.groupId;
    self.block(add);
}
@end
