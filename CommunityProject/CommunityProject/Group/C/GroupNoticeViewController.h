//
//  GroupNoticeViewController.h
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupHostInfoController.h"

@interface GroupNoticeViewController : UIViewController

@property (nonatomic,copy)NSString * publicNotice;

@property (nonatomic,assign)BOOL isHost;
//群ID
@property (nonatomic,copy)NSString * groupId;
//管理员ID
@property (nonatomic,copy)NSString * hostId;

@property (nonatomic,assign)GroupHostInfoController * hostDelegate;

@end
