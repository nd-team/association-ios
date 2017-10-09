//
//  OthersClaimModel.h
//  CommunityProject
//
//  Created by bjike on 17/5/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OthersClaimModel : JSONModel
//用户ID
@property (nonatomic,copy) NSString * userId;
//0未认领1认领别人成功信息
@property (nonatomic,copy) NSString * status;

//认领时间
@property (nonatomic,copy) NSString * claimTime;
//昵称
@property (nonatomic,copy) NSString * nickname;
//头像
@property (nonatomic,copy) NSString * userPortraitUrl;

@end
