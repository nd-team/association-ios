//
//  JoinUserModel.h
//  LoveChatProject
//
//  Created by bjike on 17/3/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "JSONModel.h"

@interface JoinUserModel : JSONModel
//投票用户id
@property (nonatomic,copy)NSString * userId;
//用户头像
@property (nonatomic,copy)NSString * userPortraitUrl;
//用户昵称
@property (nonatomic,copy)NSString * nickname;

@end
