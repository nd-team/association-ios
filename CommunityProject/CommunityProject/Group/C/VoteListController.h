//
//  VoteListController.h
//  CommunityProject
//
//  Created by bjike on 17/4/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteListController : UIViewController
//发起投票刷新列表
@property (nonatomic,assign)BOOL isRef;
//群ID
@property (nonatomic,copy)NSString * groupId;
//群名
@property (nonatomic,copy)NSString * groupName;

@end
