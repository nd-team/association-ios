//
//  ApplicationTwoModel.h
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ApplicationTwoModel : JSONModel

@property (nonatomic,copy)NSString * userId;
//昵称
@property (nonatomic,copy)NSString * nickname;
//头像
@property (nonatomic,copy)NSString * userPortraitUrl;

//拉人ID
@property (nonatomic,copy)NSString * pullUserid;
//拉人昵称
@property (nonatomic,copy)NSString * pullNickname;

@end
