//
//  GroupApplicationModel.h
//  LoveChatProject
//
//  Created by bjike on 17/3/2.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "JSONModel.h"

@interface GroupApplicationModel : JSONModel

@property (nonatomic,copy)NSString * userId;
//昵称
@property (nonatomic,copy)NSString * nickname;
//头像
@property (nonatomic,copy)NSString * avatarImage;
//状态： 0已拒绝 1已同意2已忽略
@property (nonatomic,copy)NSString * status;
//申请时间
@property (nonatomic,copy)NSString * addtime;

//申请留言
@property (nonatomic,copy)NSString * addMessage;

@end
