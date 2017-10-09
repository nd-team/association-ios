//
//  NameViewController.h
//  CommunityProject
//
//  Created by bjike on 17/3/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendDetailController.h"
#import "GroupHostInfoController.h"
#import "GroupMemberInfoController.h"
#import "CreateActivityController.h"

@interface NameViewController : UIViewController
//标题
@property (nonatomic,copy)NSString * name;
//1:个人昵称2：群昵称3：群名字4:活动名称5：活动限制人数6:兴趣联盟名字
@property (nonatomic,assign)int titleCount;
//是否是新建群聊
@property (nonatomic,assign)BOOL isChangeGroupName;
//新建群聊的成员ID
@property (nonatomic,copy)NSString * userStr;
//好友ID
@property (nonatomic,copy)NSString * friendId;
//群ID
@property (nonatomic,copy)NSString * groupId;



@property (nonatomic,assign)FriendDetailController * friendDelegate;
//空白提示
@property (nonatomic,copy)NSString * placeHolder;
//内容 //群名
@property (nonatomic,copy)NSString * content;

@property (nonatomic,assign)GroupHostInfoController * hostDelegate;
@property (nonatomic,assign)GroupMemberInfoController * memberDelegate;
@property (nonatomic,assign)CreateActivityController * createDelegate;

#pragma mark-用来刷新SDK
//群头像
@property (nonatomic,copy)NSString * headUrl;
//右侧按钮标题
@property (nonatomic,copy)NSString * rightStr;
//新建兴趣联盟爱好ID
@property (nonatomic,copy)NSString * hobbyId;

@end
