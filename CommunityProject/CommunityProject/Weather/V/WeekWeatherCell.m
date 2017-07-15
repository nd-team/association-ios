//
//  WeekWeatherCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "WeekWeatherCell.h"

@implementation WeekWeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.66];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(WeatherListModel *)model{
    _model = model;
    self.weekLabel.text = [NSString stringWithFormat:@"星期%@",_model.week];
    Info * info = _model.info;
    NSArray * lowest = info.night;
    NSArray * highest = info.day;
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@~%@°C",lowest[2],highest[2]];
//    if ([highest[1] containsObject:@"雾"]) {
//        self.weatherImage.image = [UIImage imageNamed:@"smog"];
//    }else if ([highest[1] containsObject:@"雨"]){
//        self.weatherImage.image = [UIImage imageNamed:@"smog"];
//    }else if ([highest[1] containsObject:@"雪"]){
//        self.weatherImage.image = [UIImage imageNamed:@"smog"];
//    }else if ([highest[1] containsObject:@"雷阵雨"]){
//        self.weatherImage.image = [UIImage imageNamed:@"smog"];
//    }else if ([highest[1] containsObject:@"多云"]){
//        self.weatherImage.image = [UIImage imageNamed:@"noSun"];
//    }else if ([highest[1] containsObject:@"晴"]){
//        self.weatherImage.image = [UIImage imageNamed:@"sun"];
//    }else if ([highest[1] containsObject:@"阴"]){
//        self.weatherImage.image = [UIImage imageNamed:@"noSun"];
//    }else if ([highest[1] containsObject:@"台风"]){
//        self.weatherImage.image = [UIImage imageNamed:@"typhoon"];
//    }else if ([highest[1] containsObject:@"冰雹"]){
//        self.weatherImage.image = [UIImage imageNamed:@"typhoon"];
//    }else if ([highest[1] containsObject:@"风暴"]){
//        self.weatherImage.image = [UIImage imageNamed:@"typhoon"];
//    }else if ([highest[1] containsObject:@"浮沉"]){
//        self.weatherImage.image = [UIImage imageNamed:@"typhoon"];
//    }else if ([highest[1] containsObject:@"霜冻"]){
//        self.weatherImage.image = [UIImage imageNamed:@"typhoon"];
//    }else{
//        self.weatherImage.image = [UIImage imageNamed:@"sun"];
//    }


}
@end
