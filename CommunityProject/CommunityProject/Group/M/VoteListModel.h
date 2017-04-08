//
//  VoteListModel.h
//  CommunityProject
//
//  Created by bjike on 17/4/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol OptionModel <NSObject>



@end
@interface OptionModel : JSONModel
@property (nonatomic,assign)NSInteger  idStr;
//主题
@property (nonatomic,copy)NSString * content;

@end
@interface VoteListModel : JSONModel

@property (nonatomic,copy)NSString * voteId;
//主题
@property (nonatomic,copy)NSString * voteTitle;
//头像
@property (nonatomic,copy)NSString * voteImage;
//
@property (nonatomic,copy)NSString * addTime;

@property (nonatomic,copy)NSString * endTime;
//1当前用户已投票  0未投票
@property (nonatomic,copy)NSString * status;
// 0 活动已结束 1正在进行中
@property (nonatomic,copy)NSString * timeStatus;

@property (nonatomic,strong)NSArray<OptionModel> * option;

@end
