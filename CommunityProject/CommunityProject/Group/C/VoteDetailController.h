//
//  VoteDetailController.h
//  LoveChatProject
//
//  Created by bjike on 17/3/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoteListController.h"

@interface VoteDetailController : UIViewController
@property (nonatomic,copy)NSString * groupID;
@property (nonatomic,copy)NSString * voteID;
//传参
//创建时间
@property (nonatomic,copy)NSString * createTime;
//状态
@property (nonatomic,copy)NSString * statusStr;
//投票主题
@property (nonatomic,copy)NSString * topic;
//投票主题头像
@property (nonatomic,copy)NSString * topicUrl;
//投票截止时间
@property (nonatomic,copy)NSString * endTime;
//区分是否投票
@property (nonatomic,assign)BOOL isVote;

@property (nonatomic,assign)VoteListController * delegate;

@end
