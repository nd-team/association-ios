//
//  PublicListModel.h
//  CommunityProject
//
//  Created by bjike on 17/5/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PublicListModel : JSONModel
@property (nonatomic,copy) NSString * userId;
//发起人
@property (nonatomic,copy) NSString * nickname;
//
@property (nonatomic,copy) NSString * userPortraitUrl;
//评论数量
@property (nonatomic,copy) NSString * commentNumber;
//点赞数量
@property (nonatomic,copy) NSString * likes;
//是否点赞
@property (nonatomic,copy) NSString * likesStatus;
//活动内容
@property (nonatomic,copy) NSString * content;

//公益活动图片
@property (nonatomic,copy) NSString * activesImage;
//活动标题
@property (nonatomic,copy) NSString * title;
//活动地址
@property (nonatomic,copy) NSString * address;

//1进行中0已截止2未开始
@property (nonatomic,copy) NSString * status;
//活动ID
@property (nonatomic) NSInteger  id;

@property (nonatomic,assign)CGFloat height;

@end
