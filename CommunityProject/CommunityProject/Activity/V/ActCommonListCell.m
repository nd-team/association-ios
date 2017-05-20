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
    [self.travelImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_actModel.activesImage]]] placeholderImage:[UIImage imageNamed:@"banner"]];
    if ([_actModel.status isEqualToString:@"1"]) {
        self.statusLabel.text = @"进行中";

    }else{
        self.statusLabel.text = @"已结束";
    }
}
@end
