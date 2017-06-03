//
//  AddFriendsCell.m
//  CommunityProject
//
//  Created by bjike on 2017/6/2.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AddFriendsCell.h"
#import "AddFriendController.h"

@implementation AddFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 32;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//加好友
- (IBAction)addFriendClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    AddFriendsCell * cell = (AddFriendsCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    SearchFriendModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    AddFriendController * add = [sb instantiateViewControllerWithIdentifier:@"AddFriendController"];
    add.friendId = model.userId;
    add.buttonName = @"确认添加好友";
    self.block(add);
}
-(void)setFriendModel:(SearchFriendModel *)friendModel{
    _friendModel = friendModel;
    NSString * str = [ImageUrl changeUrl:_friendModel.userPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    self.nameLabel.text = _friendModel.nickname;
    self.numberLabel.text = _friendModel.numberId;
    self.commonLabel.text = [NSString stringWithFormat:@"%ld位共同好友",_friendModel.count];
    if (_friendModel.checkFriends == 0) {
        self.isFriendBtn.hidden = NO;
    }else{
        self.isFriendBtn.hidden = YES;

    }
    if (_friendModel.sex == 1) {
        self.sexImage.image = [UIImage imageNamed:@"man"];
    }else{
        self.sexImage.image = [UIImage imageNamed:@"woman"];
    }
    switch (_friendModel.relationship) {
        case 1:
            [self.relationshipBtn setTitle:@"亲人" forState:UIControlStateNormal];
            break;
        case 2:
            [self.relationshipBtn setTitle:@"同事" forState:UIControlStateNormal];
            break;
        case 3:
            [self.relationshipBtn setTitle:@"校友" forState:UIControlStateNormal];
            break;
        default:
            [self.relationshipBtn setTitle:@"同乡" forState:UIControlStateNormal];
            break;
    }
}
@end
