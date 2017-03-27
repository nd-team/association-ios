//
//  UnknownFriendDetailController.h
//  CommunityProject
//
//  Created by bjike on 17/3/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnknownFriendDetailController : UIViewController
//判断非好友是否注册APP
@property (nonatomic,assign)BOOL isRegister;

//好友ID
@property (nonatomic,copy)NSString * friendId;
//传参过来的数据 昵称
@property (nonatomic,copy)NSString * name;
//头像
@property (nonatomic,copy)NSString * url;
@property (nonatomic,copy)NSString * age;
@property (nonatomic,assign)int sex;
@property (nonatomic,copy)NSString * phone;
@property (nonatomic,copy)NSString * recomendPerson;
@property (nonatomic,copy)NSString * email;
@property (nonatomic,copy)NSString * lingPerson;
@property (nonatomic,copy)NSString * contribute;
@property (nonatomic,copy)NSString * birthday;
@property (nonatomic,copy)NSString * prestige;
@property (nonatomic,copy)NSString * areaStr;

@end
