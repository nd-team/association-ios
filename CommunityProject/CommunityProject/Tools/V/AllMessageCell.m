//
//  AllMessageCell.m
//  CommunityProject
//
//  Created by bjike on 17/5/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AllMessageCell.h"

@implementation AllMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
