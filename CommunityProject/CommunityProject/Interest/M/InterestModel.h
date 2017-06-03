//
//  InterestModel.h
//  CommunityProject
//
//  Created by bjike on 17/4/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface InterestModel : JSONModel
@property (nonatomic,copy)NSString * groupId;
//昵称
@property (nonatomic,copy)NSString * groupName;
//头像
@property (nonatomic,copy)NSString * groupPortraitUrl;
//群人数
@property (nonatomic,copy)NSString * groupUserNumber;
//0：未加入 1群员 2 群主
@property (nonatomic,copy)NSString * status;
@end
