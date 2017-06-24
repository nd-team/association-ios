//
//  MyDownloadCell.m
//  CommunityProject
//
//  Created by bjike on 2017/6/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyDownloadCell.h"

@implementation MyDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setVideoModel:(VideoDownloadListModel *)videoModel{
    _videoModel = videoModel;
    self.titleLabel.text = _videoModel.title;
    self.mbLabel.text = _videoModel.mbStr;
}
@end
