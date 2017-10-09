//
//  WeekWeatherCell.h
//  CommunityProject
//
//  Created by bjike on 2017/7/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherListModel.h"

@interface WeekWeatherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (nonatomic,strong)WeatherListModel * model;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
