//
//  FriendDetailController.h
//  CommunityProject
//
//  Created by bjike on 17/3/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressListController.h"

@interface FriendDetailController : UIViewController
//备注
@property (nonatomic,copy)NSString * display;
//好友ID
@property (nonatomic,copy)NSString * friendId;
//传参过来的数据 昵称
@property (nonatomic,copy)NSString * name;
//头像
@property (nonatomic,copy)NSString * url;
@property (nonatomic,copy)NSString * age;
@property (nonatomic,assign)int sex;
@property (nonatomic,copy)NSString * phone;
@property (nonatomic,strong)NSString * recomendPerson;
@property (nonatomic,copy)NSString * email;
//认领人
@property (nonatomic,strong)NSString * lingPerson;
@property (nonatomic,strong)NSString * contribute;
@property (nonatomic,copy)NSString * birthday;
@property (nonatomic,strong)NSString * prestige;
@property (nonatomic,copy)NSString * areaStr;

@property (nonatomic,assign)AddressListController * listDelegate;
//判断是从通讯录进入该界面
@property (nonatomic,assign)BOOL isAddress;
//亲密度
@property (nonatomic,copy)NSString * intimacy;
@end
