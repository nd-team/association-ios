//
//  TravelCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/16.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TravelCell.h"

@implementation TravelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = 2.2;
    self.twoView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 2.2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTravelModel:(TravelModel *)travelModel{
    _travelModel = travelModel;
    self.titleLabel.text = _travelModel.title;
    self.areaLabel.text = _travelModel.address;
    [self.travelImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_travelModel.activesImage]]] placeholderImage:[UIImage imageNamed:@"banner"]];
}
@end
