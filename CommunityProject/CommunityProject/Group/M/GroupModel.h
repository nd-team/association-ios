//
//  GroupModel.h
//  LoveChatProject
//
//  Created by bjike on 17/2/9.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : JSONModel

@property (nonatomic,copy)NSString * groupId;
//昵称
@property (nonatomic,copy)NSString * groupName;
//头像
@property (nonatomic,copy)NSString * groupPortraitUrl;
//2代表创建者即群主1副群主0是群员
@property (nonatomic,copy)NSString * role;

@end
