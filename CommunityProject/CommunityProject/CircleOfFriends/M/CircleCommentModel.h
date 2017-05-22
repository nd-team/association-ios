//
//  CircleCommentModel.h
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CircleAnswerModel <NSObject>



@end
@interface CircleAnswerModel : JSONModel
//回复用户id
@property (nonatomic,strong)NSString * userId;
 //回复人昵称
@property (nonatomic,strong)NSString * nickname;
//回复人头像
@property (nonatomic,strong)NSString * userPortraitUrl;

//回复内容
@property (nonatomic,strong)NSString * content;
//回复评论id
@property (nonatomic,strong)NSString * fromId;
//回复ID
@property (nonatomic,assign)NSInteger  id;
 //回复用户id
@property (nonatomic,strong)NSString * fromUserId;
//回复用户昵称
@property (nonatomic,strong)NSString * fromNickname;

//回复人头像
@property (nonatomic,strong)NSString * fromPortraitUrl;

//回复内容
@property (nonatomic,strong)NSString * fromContent;
//回复时间
@property (nonatomic,strong)NSString * commentTime;
//保存tableview的行高
@property (nonatomic,assign)CGFloat height;

@end
@interface CircleCommentModel : JSONModel
@property (nonatomic,strong)NSString * userId;
//昵称
@property (nonatomic,strong)NSString * nickname;
//头像
@property (nonatomic,strong)NSString * userPortraitUrl;

//内容
@property (nonatomic,strong)NSString * content;
//评论时间
@property (nonatomic,strong)NSString * commentTime;
//评论ID
@property (nonatomic,assign)NSInteger  id;
@property (nonatomic,strong)NSArray<CircleAnswerModel> *replyUsers;
//保存tableview的行高
@property (nonatomic,assign)CGFloat height;

@end
