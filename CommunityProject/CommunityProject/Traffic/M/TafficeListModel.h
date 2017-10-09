//
//  TafficeListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/7/6.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TafficeListModel : JSONModel

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
//图片
@property (nonatomic,copy) NSString * image;

//时间
@property (nonatomic,copy)NSString * time;
//评论次数
@property (nonatomic,copy) NSString * commentNumber;
//分享次数
@property (nonatomic,copy) NSString * shareNumber;
//点赞数量
@property (nonatomic,copy) NSString * likes;
//是否点赞
@property (nonatomic,copy) NSString * statusLikes;

@property (nonatomic,assign)CGFloat height;

@end
