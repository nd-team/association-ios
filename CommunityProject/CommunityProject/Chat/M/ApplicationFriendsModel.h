//
//  ApplicationFriendsModel.h
//  LoveChatProject
//
//  Created by bjike on 17/1/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationFriendsModel : JSONModel
@property (nonatomic,copy)NSString * userId;
//昵称
@property (nonatomic,copy)NSString * nickname;
//申请留言
@property (nonatomic,copy)NSString * addFriendMessage;
//申请时间
@property (nonatomic,copy)NSString * addtime;
//头像
@property (nonatomic,copy)NSString * userPortraitUrl;
//邮箱
@property (nonatomic,copy)NSString <Optional>* email;
//电话
@property (nonatomic,copy)NSString * mobile;
//状态
@property (nonatomic,copy)NSString * status;

@end
