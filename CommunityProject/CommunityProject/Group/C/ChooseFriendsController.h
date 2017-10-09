//
//  ChooseFriendsController.h
//  CommunityProject
//
//  Created by bjike on 17/3/31.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MemberListController.h"

@interface ChooseFriendsController : UIViewController
//群主ID
@property (nonatomic,copy)NSString * hostId;
//群ID
@property (nonatomic,copy)NSString * groupId;
//标题
@property (nonatomic,copy)NSString * name;
//区别是干什么的 1:选择管理员2：新建群聊3：拉人4：踢人（单选、多选）5:兴趣联盟
@property (nonatomic,assign)int dif;

@property (nonatomic,assign)MemberListController * delegate;

@property (nonatomic,strong)NSMutableArray * baseArr;
//右侧按钮名字
@property (nonatomic,copy)NSString * rightName;

@end
