//
//  GroupMemberInfoController.h
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberInfoController : UIViewController
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

@end
