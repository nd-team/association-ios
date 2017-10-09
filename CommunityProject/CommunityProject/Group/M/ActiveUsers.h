//
//  ActiveUsers.h
//  CommunityProject
//
//  Created by bjike on 17/4/11.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ActiveUsers : JSONModel
//报名用户id
@property (nonatomic,copy)NSString * userId;
//用户头像
@property (nonatomic,copy)NSString * avatarImage;

@property (nonatomic,copy)NSString * nickname;

@end
