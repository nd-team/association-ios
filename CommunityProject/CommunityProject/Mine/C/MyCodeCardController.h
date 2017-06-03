//
//  MyCodeCardController.h
//  CommunityProject
//
//  Created by bjike on 2017/5/31.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCodeCardController : UIViewController
//昵称
@property (nonatomic,copy)NSString * nickname;
//头像
@property (nonatomic,copy)NSString * userPortraitUrl;
//性别
@property (nonatomic,assign)NSInteger  sex;
//年龄
@property (nonatomic,copy)NSString * ageStr;
//账号
@property (nonatomic,copy)NSString * userId;

@end
