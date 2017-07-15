//
//  WeatherListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/7/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Info <NSObject>



@end
@interface Info : JSONModel
//字符串（需要里面的温度和气候数据）
@property (nonatomic,strong) NSArray * day;
@property (nonatomic,strong) NSArray * night;
@end
@interface WeatherListModel : JSONModel
@property (nonatomic,copy) NSString * week;
@property (nonatomic,copy) NSString * date;
@property (nonatomic,copy) NSString * nongli;
@property (nonatomic,strong) Info * info;

@end
