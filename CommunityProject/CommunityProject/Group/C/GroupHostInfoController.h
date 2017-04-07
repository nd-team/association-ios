//
//  GroupHostInfoController.h
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupHostInfoController : UIViewController
//群ID
@property (nonatomic,copy)NSString * groupId;
//群名
@property (nonatomic,copy)NSString * groupName;
//群公告
@property (nonatomic,copy)NSString * publicNotice;
//群内昵称
@property (nonatomic,copy)NSString * nickname;
//当前用户ID
@property (nonatomic,copy)NSString * userId;
//群头像
@property (nonatomic,copy)NSString * headUrl;
//区分群主和管理员
@property (nonatomic,assign)BOOL isHost;
//群主ID
@property (nonatomic,copy)NSString * hostId;

@property (nonatomic,assign)BOOL isRef;
@end
