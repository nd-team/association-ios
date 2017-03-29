//
//  MemberListController.h
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberListController : UIViewController

@property (nonatomic,strong)NSMutableArray * collectArr;
//群ID
@property (nonatomic,copy)NSString * groupId;
//当前用户ID
@property (nonatomic,copy)NSString * userId;
//是否是管理员
@property (nonatomic,assign)BOOL isManager;

@end
