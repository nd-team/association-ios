//
//  CommentsListModel.h
//  CommunityProject
//
//  Created by bjike on 17/5/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommentsListModel : JSONModel
@property (nonatomic,strong)NSString * userId;
//昵称
@property (nonatomic,strong)NSString * nickname;
//头像
@property (nonatomic,strong)NSString * userPortraitUrl;

//内容
@property (nonatomic,strong)NSString * content;
//发布时间
@property (nonatomic,strong)NSString * commentTime;
//点赞数量
@property (nonatomic,strong)NSString * likes;
//0:未点赞1：已点赞
@property (nonatomic,strong)NSString * likesStatus;
//被回复人ID
@property (nonatomic,strong)NSString * fromUserId;

//昵称
@property (nonatomic,strong)NSString * fromNickname;
//被回复人 头像
@property (nonatomic,strong)NSString * fromPortraitUrl;

//回复内容
@property (nonatomic,strong)NSString * fromContent;

//说说ID
@property (nonatomic,assign)NSInteger  id;
@property (nonatomic,assign)CGFloat  height;

@end
