//
//  RaiseListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/7/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RaiseListModel : JSONModel
//发布人
@property (nonatomic,copy) NSString * nickname;
//发布者头像
@property (nonatomic,copy) NSString * userPortraitUrl;

@property (nonatomic,copy)NSString * idStr;
//标题
@property (nonatomic,copy) NSString * title;

//目的
@property (nonatomic,copy) NSString * objective;
//总资金
@property (nonatomic,copy) NSString * capital;
//已筹备资金
@property (nonatomic,copy) NSString * contribution;
//百分比
@property (nonatomic,copy) NSString * percent;

//图片
@property (nonatomic,copy) NSString * image;

//剩余天数
@property (nonatomic,copy)NSString * days;
//评论次数
@property (nonatomic,copy) NSString * commentNumber;
//分享次数
@property (nonatomic,copy) NSString * shareNumber;
//点赞数量
@property (nonatomic,copy) NSString * likes;
//是否点赞
@property (nonatomic,copy) NSString * likeStatus;
//类型1：产品众筹2.求助众筹
@property (nonatomic,copy) NSString * type;

@end
