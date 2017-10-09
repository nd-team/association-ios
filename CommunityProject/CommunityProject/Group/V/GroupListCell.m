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
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GroupModel *)model{
    _model = model;
    self.nameLabel.text = _model.groupName;
    NSString *  str = [ImageUrl changeUrl:_model.groupPortraitUrl];
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,str];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl] placeholderImage:[UIImage imageNamed:@"default"]];
}
@end
