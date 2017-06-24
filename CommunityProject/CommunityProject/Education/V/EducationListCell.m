//
//  EducationListCell.m
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "EducationListCell.h"

@implementation EducationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setListModel:(EducationListModel *)listModel{
    _listModel = listModel;
    self.titleLabel.text = _listModel.title;
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_listModel.imageUrl]]] placeholderImage:[UIImage imageNamed:@"banner3"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@/%@",_listModel.nickname,_listModel.playTime];
}

@end
