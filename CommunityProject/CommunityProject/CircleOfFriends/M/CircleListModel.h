//
//  CircleListModel.h
//  CommunityProject
//
//  Created by bjike on 17/4/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CircleListModel : JSONModel
@property (nonatomic,copy)NSString * userId;
//昵称
@property (nonatomic,copy)NSString * nickname;
//头像
@property (nonatomic,copy)NSString * userPortraitUrl;

//内容
@property (nonatomic,copy)NSString * content;
//发布时间
@property (nonatomic,copy)NSString * releaseTime;
//点赞数量
@property (nonatomic,copy)NSString * likedNumber;
//评论数量
@property (nonatomic,copy)NSString * commentNumber;
//0:未点赞1：已点赞
@property (nonatomic,copy)NSString * likeStatus;
//图片
@property (nonatomic,strong)NSArray * images;

@property (nonatomic,assign)NSInteger  id;

@end
