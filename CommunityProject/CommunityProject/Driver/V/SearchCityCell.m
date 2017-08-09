//
//  SearchCityCell.m
//  CommunityProject
//
//  Created by bjike on 2017/8/5.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SearchCityCell.h"

@implementation SearchCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setBrandModel:(CarBrandModel *)brandModel{
    _brandModel = brandModel;
    self.areaNameLabel.text = _brandModel.name;
}
-(void)setSonModel:(SonModel *)sonModel{
    _sonModel = sonModel;
    self.areaNameLabel.text = _sonModel.type;
    
}
@end
