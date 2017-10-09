//
//  SetPersonController.h
//  CommunityProject
//
//  Created by bjike on 17/3/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPersonController : UIViewController
//朋友ID
@property (nonatomic,copy)NSString * friendId;
//会话类型
@property(nonatomic) RCConversationType conversationType;
//会话昵称
@property (nonatomic,copy)NSString * nickname;
@end
