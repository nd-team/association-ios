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
    //0是黑1是白
    self.lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.26];


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
    NSString * weatherStr =[NSString stringWithFormat:@"%@",highest[1]];
    if ([weatherStr containsString:@"雾"]) {
        self.weatherImage.image = [UIImage imageNamed:@"fog"];
    }else if ([weatherStr containsString:@"雨"]){
        self.weatherImage.image = [UIImage imageNamed:@"rainSmall"];
    }else if ([weatherStr containsString:@"雪"]){
        self.weatherImage.image = [UIImage imageNamed:@"snowSmall"];
    }else if ([weatherStr containsString:@"雷阵雨"]){
        self.weatherImage.image = [UIImage imageNamed:@"thunSnow"];
    }else if ([weatherStr containsString:@"多云"]){
        self.weatherImage.image = [UIImage imageNamed:@"noSun"];
    }else if ([weatherStr containsString:@"晴"]){
        self.weatherImage.image = [UIImage imageNamed:@"sun"];
    }else if ([weatherStr containsString:@"阴"]){
        self.weatherImage.image = [UIImage imageNamed:@"overcastSmall"];
    }else if ([weatherStr containsString:@"台风"]){
        self.weatherImage.image = [UIImage imageNamed:@"typhoon"];
    }else if ([weatherStr containsString:@"冰雹"]){
        self.weatherImage.image = [UIImage imageNamed:@"hailSmall"];
    }else if ([weatherStr containsString:@"风暴"]){
        self.weatherImage.image = [UIImage imageNamed:@"stormSmall"];
    }else if ([weatherStr containsString:@"浮沉"]){
        self.weatherImage.image = [UIImage imageNamed:@"upSmall"];
    }else if ([weatherStr containsString:@"霜冻"]){
        self.weatherImage.image = [UIImage imageNamed:@"frostSmall"];
    }else if ([weatherStr containsString:@"龙卷风"]){
        self.weatherImage.image = [UIImage imageNamed:@"tornado"];
    }else{
        self.weatherImage.image = [UIImage imageNamed:@"sun"];
    }


}
@end
