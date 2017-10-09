//
//  DriverRecordCell.m
//  CommunityProject
//
//  Created by bjike on 2017/8/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "DriverRecordCell.h"

@implementation DriverRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setRecordModel:(DriverRecordModel *)recordModel{
    _recordModel = recordModel;
    self.timeLabel.text = _recordModel.time;
    self.startAddressLabel.text = _recordModel.fromAddress;
    self.endAddressLabel.text = _recordModel.destination;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",_recordModel.money];
    NSInteger status = [_recordModel.status integerValue];
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
            self.statusLabel.text = @"取消订单";

            break;
        case 4:
            self.statusLabel.text = @"司机已接单";

            break;
        default:
            self.statusLabel.text = @"司机完成";

            break;
    }
}
@end
