//
//  ActCommonListCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ActCommonListCell.h"

@implementation ActCommonListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = 2.2;
    self.twoView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 2.2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setActModel:(PlatformActListModel *)actModel{
    _actModel = actModel;
    self.titleLabel.text = _actModel.title;
    self.areaLabel.text = _actModel.address;
    //服务器图片删掉了，所以要做这个处理，其他地方可能也需要哦，毕竟后台动不动就删数据库
    if ([ImageUrl isEmptyStr:_actModel.activesImage]) {
        self.travelImageView.image = [UIImage imageNamed:@"banner"];
    }else{
        [self.travelImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_actModel.activesImage]]] placeholderImage:[UIImage imageNamed:@"banner"]];
    }
    if ([_actModel.status isEqualToString:@"1"]) {
        self.statusLabel.text = @"进行中";

    }else{
        self.statusLabel.text = @"已结束";
    }
}
@end
