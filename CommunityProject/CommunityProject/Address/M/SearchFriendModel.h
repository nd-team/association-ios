//
//  SearchFriendModel.h
//  LoveChatProject
//
//  Created by bjike on 17/1/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchFriendModel : JSONModel

@property (nonatomic,copy)NSString * userId;
//昵称
@property (nonatomic,copy)NSString * nickname;
//头像
@property (nonatomic,copy)NSString * userPortraitUrl;
//共同好友
@property (nonatomic,assign)NSInteger  count;
//关系(1亲人2同事3校友4同乡)
@property (nonatomic,assign)NSInteger  relationship;
//编号
@property (nonatomic,copy)NSString * numberId;
//性别（1男 2女）
@property (nonatomic,assign)NSInteger  sex;
//1好友  0非好友
@property (nonatomic,assign)NSInteger  checkFriends;

@end
