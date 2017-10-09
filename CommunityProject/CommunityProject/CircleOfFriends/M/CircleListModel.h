//
//  CircleListModel.h
//  CommunityProject
//
//  Created by bjike on 17/4/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CircleListModel : JSONModel
@property (nonatomic,strong)NSString * userId;
//昵称
@property (nonatomic,strong)NSString * nickname;
//头像
@property (nonatomic,strong)NSString * userPortraitUrl;

//内容
@property (nonatomic,strong)NSString * content;
//发布时间
@property (nonatomic,strong)NSString * releaseTime;
//点赞数量
@property (nonatomic,strong)NSString * likedNumber;
//评论数量
@property (nonatomic,strong)NSString * commentNumber;
//0:未点赞1：已点赞
@property (nonatomic,strong)NSString * likeStatus;
//图片
@property (nonatomic,strong)NSArray * images;
//说说ID
@property (nonatomic,assign)NSInteger  id;

@property (nonatomic,assign)CGFloat height;

@end
