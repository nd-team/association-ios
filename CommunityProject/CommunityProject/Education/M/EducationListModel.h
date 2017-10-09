//
//  EducationListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface EducationListModel : JSONModel

@property (nonatomic,copy) NSString * userId;
//发布人
@property (nonatomic,copy) NSString * nickname;
//发布者头像
@property (nonatomic,copy) NSString * userPortraitUrl;

@property (nonatomic,copy)NSString * idStr;
//视频第一帧
@property (nonatomic,copy) NSString * imageUrl;
//教学标题
@property (nonatomic,copy) NSString * title;
//教学内容
@property (nonatomic,copy) NSString * content;
//视频地址
@property (nonatomic,copy)NSString * videoUrl;
//点赞数量
@property (nonatomic,copy) NSString * likes;
//是否点赞
@property (nonatomic,assign) NSInteger likesStatus;
//是否收藏
@property (nonatomic,assign) NSInteger checkCollect;

//评论数量
@property (nonatomic,copy)NSString * commentNumber;
//收藏数量
@property (nonatomic,copy) NSString * collectionNumber;
//下载数量
@property (nonatomic,copy) NSString * downloadNumber;
//分享数量
@property (nonatomic,copy) NSString * shareNumber;
//视频时间
@property (nonatomic,copy) NSString * time;
//视频时长
@property (nonatomic,copy) NSString * playTime;

@end
