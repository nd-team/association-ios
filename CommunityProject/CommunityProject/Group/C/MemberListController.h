//
//  MemberListController.h
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupHostInfoController.h"

@interface MemberListController : UIViewController

@property (nonatomic,strong)NSMutableArray * collectArr;
//群ID
@property (nonatomic,copy)NSString * groupId;
//群名称
@property (nonatomic,copy)NSString * groupName;
//群头像
@property (nonatomic,copy)NSString * groupUrl;

//当前用户ID
@property (nonatomic,copy)NSString * userId;
//是否是管理员
@property (nonatomic,assign)BOOL isManager;
//群主ID
@property (nonatomic,copy)NSString * hostId;
//刷新成员列表
@property (nonatomic,assign)BOOL isRef;

@property (nonatomic,assign)GroupHostInfoController * delegate;

@end
