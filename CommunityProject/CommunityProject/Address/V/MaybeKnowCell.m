//
//  MaybeKnowCell.m
//  CommunityProject
//
//  Created by bjike on 2017/6/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MaybeKnowCell.h"
#import "AddFriendController.h"

@implementation MaybeKnowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 25;
}
//加好友
- (IBAction)addFriendClick:(id)sender {
    //跳转加好友界面 传参过去ID
    UIButton * button = (UIButton *)sender;
    MaybeKnowCell * cell = (MaybeKnowCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    SearchFriendModel * model = self.collectionArr[indexPath.row];
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
    
    switch (_friendModel.relationship) {
        case 0:
            self.relationshipBtn.hidden = YES;
            break;
        case 1:
            [self.relationshipBtn setTitle:@"亲人" forState:UIControlStateNormal];
            break;
        case 2:
            [self.relationshipBtn setTitle:@"同事" forState:UIControlStateNormal];
            break;
        case 3:
            [self.relationshipBtn setTitle:@"校友" forState:UIControlStateNormal];
            break;
        case 4:
            [self.relationshipBtn setTitle:@"同乡" forState:UIControlStateNormal];
            break;
        case 5:
            [self.relationshipBtn setTitle:@"同行" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
     
}

@end
