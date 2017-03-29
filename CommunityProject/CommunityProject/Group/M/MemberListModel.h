//
//  MemberListModel.h
//  LoveChatProject
//
//  Created by bjike on 17/2/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberListModel : JSONModel
@property (nonatomic,copy)NSString * userId;
//昵称
@property (nonatomic,copy)NSString * userName;
//头像
@property (nonatomic,copy)NSString * userPortraitUrl;
//1代表创建者即群主0是群员
@property (nonatomic,copy)NSString * role;

@property (nonatomic,copy)NSString * mobile;

@end
