//
//  GroupListCell.m
//  LoveChatProject
//
//  Created by bjike on 17/2/9.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupListCell.h"

@implementation GroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 20;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GroupModel *)model{
    _model = model;
    self.nameLabel.text = _model.groupName;
    NSString * str;
    if ([_model.groupPortraitUrl containsString:@"\\"]) {
        str = [_model.groupPortraitUrl stringByReplacingCharactersInRange:[_model.groupPortraitUrl rangeOfString:@"\\"] withString:@"/"];
    }else{
        str = _model.groupPortraitUrl;
    }
    NSString * encodeUrl = [NSString stringWithFormat:@"http://192.168.0.212%@",str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
}
@end
