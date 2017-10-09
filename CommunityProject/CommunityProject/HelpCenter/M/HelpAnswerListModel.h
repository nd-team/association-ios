//
//  HelpAnswerListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HelpAnswerListModel : JSONModel

@property (nonatomic,copy) NSString * userId;
//评论人
@property (nonatomic,copy) NSString * nickname;
//评论头像
@property (nonatomic,copy) NSString * userPortraitUrl;

@property (nonatomic,copy)NSString * idStr;
//内容
@property (nonatomic,copy) NSString * content;
//时间
@property (nonatomic,copy)NSString * time;
//回复评论数量
@property (nonatomic,copy) NSString * commentNumber;
//回复点赞数量
@property (nonatomic,copy) NSString * likes;
//1已点赞0未点赞
@property (nonatomic,copy) NSString * likesStatus;
//评论内容高度
@property (nonatomic,assign)CGFloat height;

@end
