//
//  AddFriendController.h
//  CommunityProject
//
//  Created by bjike on 17/3/27.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendController : UIViewController
//好友ID
@property (nonatomic,copy)NSString * friendId;
//传参过来按钮的名字
@property (nonatomic,copy)NSString * buttonName;
//群ID
@property (nonatomic,copy)NSString * groupId;

@end
