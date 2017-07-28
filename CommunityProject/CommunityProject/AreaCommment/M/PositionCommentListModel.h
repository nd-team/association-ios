//
//  PositionCommentListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/7/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PositionCommentListModel : JSONModel

//@property (nonatomic,strong)NSString * userId;
//昵称
@property (nonatomic,strong)NSString * nickname;
//头像
@property (nonatomic,strong)NSString * headPath;

//内容
@property (nonatomic,strong)NSString * content;
//发布时间
@property (nonatomic,strong)NSString * createTime;
//点赞数量
@property (nonatomic,strong)NSString * likes;
//评分
@property (nonatomic,strong)NSString * scoreType;
//0:未点赞1：已点赞
@property (nonatomic,assign)bool  alreadyLikes;
//图片
@property (nonatomic,strong)NSArray * images;
//说说ID
@property (nonatomic,assign)NSInteger  idStr;

@property (nonatomic,strong)NSString * visibleType;
//计算总高度
@property (nonatomic,assign)CGFloat height;

@end
