//
//  MyPeopleListModel.h
//  CommunityProject
//
//  Created by bjike on 17/5/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyPeopleListModel : JSONModel
//昵称
@property (nonatomic,strong)NSString * nickname;
//头像
@property (nonatomic,strong)NSString * userPortraitUrl;
//用户ID
@property (nonatomic,strong)NSString * userId;
//好友状态 0非好友1好友
@property (nonatomic,strong)NSString * status;
//推荐人
@property (nonatomic,strong)NSString * recommendUser;

@property (nonatomic,strong)NSString * sex;

@end
