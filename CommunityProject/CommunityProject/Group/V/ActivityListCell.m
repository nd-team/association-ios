//
//  ActivityListCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ActivityListCell.h"

@implementation ActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setActModel:(ActivityListModel *)actModel{
    _actModel = actModel;
    
    NSString * str = [ImageUrl changeUrl:_actModel.activesImage];
   
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,str]]];
    self.areaLabel.text = [NSString stringWithFormat:@"地点：%@",_actModel.activesAddress];
    self.titleLabel.text = _actModel.activesTitle;
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@",_actModel.activesStart];
    self.introduceLabel.text = [NSString stringWithFormat:@"介绍：%@",_actModel.activesContent];
    NSString * detailTime = [NowDate currentDetailTime];
    NSComparisonResult result = [detailTime compare:_actModel.activesClosing];
    if (result == NSOrderedDescending){
        [self commonOneUI];
    }else{
        //相等小于
        [self commonTwoUI];
    }
}
-(void)commonOneUI{
    self.statusImage.image = [UIImage imageNamed:@"endAct.png"];
    self.statusLabel.text = @"已结束";
    self.statusLabel.textColor = UIColorFromRGB(0x999999);

}
-(void)commonTwoUI{
    self.statusImage.image = [UIImage imageNamed:@"doing.png"];
    self.statusLabel.text = @"进行中";
    self.statusLabel.textColor = UIColorFromRGB(0xffffff);
 
}
@end
