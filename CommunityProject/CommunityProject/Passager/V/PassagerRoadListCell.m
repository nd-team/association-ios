//
//  PassagerRoadListCell.m
//  CommunityProject
//
//  Created by bjike on 2017/8/16.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PassagerRoadListCell.h"

@implementation PassagerRoadListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 2.5;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setRoadModel:(DriverRecordModel *)roadModel{
    _roadModel = roadModel;
    self.timeLabel.text = _roadModel.time;
    self.startAreaLabel.text = _roadModel.fromAddress;
    self.endAreaLabel.text = _roadModel.destination;
    NSInteger status = [_roadModel.status integerValue];
    switch (status) {
        case 0:
            self.statusLabel.text = @"未开始";
 
            break;
        case 1:
            self.statusLabel.text = @"进行中";
 
            break;
        case 2:
            self.statusLabel.text = @"已完成";

            break;
        case 3:
            self.statusLabel.text = @"取消";
   
            break;
        case 4:
            self.statusLabel.text = @"未接到乘客";
 
            break;
        default:
            self.statusLabel.text = @"司机完成";

            break;
    }
}
@end
