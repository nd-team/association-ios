//
//  DriverGrobListCell.m
//  CommunityProject
//
//  Created by bjike on 2017/8/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "DriverGrobListCell.h"

@implementation DriverGrobListCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.headImageView zy_cornerRadiusRoundingRect];
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)grobClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    DriverGrobListCell * cell = (DriverGrobListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    DriverGrobListModel * model = self.dataArr[indexPath.row];
    NSArray * coorArr = [model.fromDegree componentsSeparatedByString:@","];
    self.orderBlock(model.fromAddress, model.destination, model.mobile, CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]), CLLocationCoordinate2DMake([coorArr[1] floatValue], [coorArr[0] floatValue]),model.userPortraitUrl,model.idStr,model.kilometre,model.money,model.time);
    
    
}
-(void)setListModel:(DriverGrobListModel *)listModel{
    _listModel = listModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_listModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default.png"]];
    self.nameLabel.text = _listModel.userName;
    self.distanceLabel.text = [NSString stringWithFormat:@"距离%@公里",_listModel.kilometre];
    self.areaLabel.text = _listModel.fromAddress;
    

}
@end
