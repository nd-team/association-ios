//
//  PersonBaseInfoController.h
//  CommunityProject
//
//  Created by bjike on 17/4/26.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineController.h"

@interface PersonBaseInfoController : UIViewController
//账号
@property (nonatomic,copy)NSString * userId;
//昵称
@property (nonatomic,copy)NSString * nickname;
//头像
@property (nonatomic,copy)NSString * userPortraitUrl;
//性别
@property (nonatomic,assign)NSInteger  sex;
//电话
@property (nonatomic,copy)NSString * mobile;
//邮箱
@property (nonatomic,copy)NSString * email;
//年龄
@property (nonatomic,copy)NSString * ageStr;
//推荐人
@property (nonatomic,copy)NSString * recommendStr;
//认领人
@property (nonatomic,copy)NSString * lingStr;
//生日
@property (nonatomic,copy)NSString * birthday;
//贡献值
@property (nonatomic,copy)NSString * contributeCount;
//信誉值
@property (nonatomic,copy)NSString * prestigeCount;
//经验值
@property (nonatomic,copy)NSString * expCount;

//地址
@property (nonatomic,copy)NSString * address;
@property (nonatomic,assign)MineController * delegete;

@end
