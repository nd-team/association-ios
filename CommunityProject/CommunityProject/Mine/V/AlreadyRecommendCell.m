//
//  AlreadyRecommendCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/26.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AlreadyRecommendCell.h"

@implementation AlreadyRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(AlreadyRecommendModel *)model{
    _model = model;
    self.nameLabel.text = _model.fullName;
    self.phoneLabel.text = _model.mobile;
    self.codeLabel.text = _model.recommendId;
    
}
@end
