//
//  PersonMoreInfoController.h
//  CommunityProject
//
//  Created by bjike on 17/4/27.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonMoreInfoController : UIViewController

//是否是当前用户
@property (nonatomic,assign)BOOL isCurrent;

@property (nonatomic,copy)NSString * friendId;

@property (nonatomic,copy)NSString * name;
//生日
@property (nonatomic,copy)NSString * birthday;

@end
