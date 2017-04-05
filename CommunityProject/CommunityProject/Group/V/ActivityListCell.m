//
//  ActivityListCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ActivityListCell.h"

@implementation ActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setActModel:(ActivityListModel *)actModel{
    _actModel = actModel;
    
    NSString * str = [ImageUrl changeUrl:_actModel.activesImage];
   
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,str]]];
    self.areaLabel.text = [NSString stringWithFormat:@"地点：%@",_actModel.activesAddress];
    self.titleLabel.text = _actModel.activesTitle;
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@~%@",_actModel.activesStart,_actModel.activesEnd];
    self.introduceLabel.text = [NSString stringWithFormat:@"介绍：%@",_actModel.activesContent];
    NSString * detailTime = [NowDate currentDetailTime];
    int year1 = [[self cutBigTime:[self cutString:detailTime][0]][0]intValue];
    int month1 = [[self cutBigTime:[self cutString:detailTime][0]][1]intValue];
    int day1 = [[self cutBigTime:[self cutString:detailTime][0]][2]intValue];
    int hour1 = [[self cutSmallTime:[self cutString:detailTime][1]][0]intValue];
    int minute1 = [[self cutSmallTime:[self cutString:detailTime][1]][1]intValue];
    int second1 = [[self cutSmallTime:[self cutString:detailTime][1]][2]intValue];
    int year2 = [[self cutBigTime:[self cutString:_actModel.activesEnd][0]][0]intValue];
    int month2 = [[self cutBigTime:[self cutString:_actModel.activesEnd][0]][1]intValue];
    int day2 = [[self cutBigTime:[self cutString:_actModel.activesEnd][0]][2]intValue];
    int hour2 = [[self cutSmallTime:[self cutString:_actModel.activesEnd][1]][0]intValue];
    int minute2 = [[self cutSmallTime:[self cutString:_actModel.activesEnd][1]][1]intValue];
    int second2 = [[self cutSmallTime:[self cutString:_actModel.activesEnd][1]][2]intValue];
    if ((year1>year2)||(year1<=year2&&month1>month2)||(year1<=year2&&month1<=month2&&day1>day2)||(year1<=year2&&month1<=month2&&day1<=day2&&hour1>hour2)||(year1<=year2&&month1<=month2&&day1<=day2&&hour1<=hour2&&minute1>minute2)||(year1<=year2&&month1<=month2&&day1<=day2&&hour1<=hour2&&minute1<=minute2&&second1>second2)) {
        self.statusImage.image = [UIImage imageNamed:@"endAct.png"];
        self.statusLabel.text = @"已结束";
        self.statusLabel.textColor = UIColorFromRGB(0x999999);
    }else{
        self.statusImage.image = [UIImage imageNamed:@"doing.png"];
        self.statusLabel.text = @"进行中";
        self.statusLabel.textColor = UIColorFromRGB(0xffffff);
    }

}
-(NSArray *)cutString:(NSString *)time{
    NSArray * arr = [time componentsSeparatedByString:@" "];
    return arr;
}
-(NSArray *)cutBigTime:(NSString *)time{
    NSArray * arr = [time componentsSeparatedByString:@"-"];
    return arr;
}
-(NSArray *)cutSmallTime:(NSString *)time{
    NSArray * arr = [time componentsSeparatedByString:@":"];
    return arr;
}
@end
