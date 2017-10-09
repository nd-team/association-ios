//
//  HelpListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HelpListModel : JSONModel

@property (nonatomic,copy) NSString * userId;
//发布人
@property (nonatomic,copy) NSString * nickname;
//发布者头像
@property (nonatomic,copy) NSString * userPortraitUrl;

@property (nonatomic,copy)NSString * idStr;
//标题
@property (nonatomic,copy) NSString * title;
//内容
@property (nonatomic,copy) NSString * content;
//时间
@property (nonatomic,copy)NSString * time;
//回答数量
@property (nonatomic,copy) NSString * helpNumber;
//贡献币
@property (nonatomic,copy) NSString * contributionCoin;


@end
