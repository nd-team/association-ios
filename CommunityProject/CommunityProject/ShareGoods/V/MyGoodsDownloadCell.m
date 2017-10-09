//
//  MyGoodsDownloadCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyGoodsDownloadCell.h"

@implementation MyGoodsDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headLabel.layer.cornerRadius = 5;
    self.headLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDownloadModel:(MyGoodsDownloadModel *)downloadModel{
    _downloadModel = downloadModel;
    self.titleLabel.text = _downloadModel.title;
    self.timeLabel.text = _downloadModel.time;
    self.KBLabel.text = _downloadModel.kbStr;
    if ([_downloadModel.type isEqualToString:@"W"]) {
        self.headLabel.backgroundColor = UIColorFromRGB(0x06abf5);
    }else if ([_downloadModel.type isEqualToString:@"X"]){
        self.headLabel.backgroundColor = UIColorFromRGB(0x23da27);
    }else{
        self.headLabel.backgroundColor = UIColorFromRGB(0xff6d2a);

    }
}
@end
