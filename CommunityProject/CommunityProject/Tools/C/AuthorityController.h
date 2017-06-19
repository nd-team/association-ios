//
//  AuthorityController.h
//  CommunityProject
//
//  Created by bjike on 2017/6/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityRecommendController.h"
#import "SendEducationController.h"

@interface AuthorityController : UIViewController
//朋友圈权限
@property (nonatomic,assign)ActivityRecommendController * delegate;
//三分钟教学权限
@property (nonatomic,assign)SendEducationController * sendDelegate;
//标记类型1朋友圈2三分钟
@property (nonatomic,assign)int type;

@end
