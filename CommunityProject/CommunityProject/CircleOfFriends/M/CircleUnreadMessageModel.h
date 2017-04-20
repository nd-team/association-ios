//
//  CircleUnreadMessageModel.h
//  CommunityProject
//
//  Created by bjike on 17/4/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CircleUnreadMessageModel : JSONModel

@property (nonatomic,strong)NSString * userId;
//昵称
@property (nonatomic,strong)NSString * nickname;
//头像
@property (nonatomic,strong)NSString * userPortraitUrl;
//内容
@property (nonatomic,strong)NSString * content;
//文章ID
@property (nonatomic,strong)NSString * articleId;
//文章头像
@property (nonatomic,strong)NSString * articleImages;
//评论ID
@property (nonatomic,assign)NSInteger  id;
//评论时间
@property (nonatomic,copy)NSString * commentTime;

@end
