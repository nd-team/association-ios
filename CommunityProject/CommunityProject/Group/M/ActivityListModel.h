//
//  ActivityListModel.h
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ActivityListModel : JSONModel
//活动ID
@property (nonatomic,copy)NSString *  activesId;
//活动标题
@property (nonatomic,copy)NSString * activesTitle;
//活动头像
@property (nonatomic,copy)NSString * activesImage;
//活动限制人数
@property (nonatomic,copy)NSString * activesLimit;
//活动开始时间
@property (nonatomic,copy)NSString * activesStart;
//活动结束时间
@property (nonatomic,copy)NSString * activesEnd;
//活动截止时间
@property (nonatomic,copy)NSString * activesClosing;

//活动地址
@property (nonatomic,copy)NSString * activesAddress;
//活动介绍
@property (nonatomic,copy)NSString * activesContent;
//是否报名0：没报名1已报名
@property (nonatomic,copy)NSString *  status;

@end
