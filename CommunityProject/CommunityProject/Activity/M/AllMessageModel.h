//
//  AllMessageModel.h
//  CommunityProject
//
//  Created by bjike on 2017/6/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AllMessageModel : JSONModel
@property (nonatomic,strong)NSString * userId;
//昵称
@property (nonatomic,strong)NSString * nickname;
//头像
@property (nonatomic,strong)NSString * userPortraitUrl;

//内容
@property (nonatomic,strong)NSString * content;
//评论时间
@property (nonatomic,strong)NSString * commentTime;
//活动ID
@property (nonatomic,strong)NSString * articleId;

@end
