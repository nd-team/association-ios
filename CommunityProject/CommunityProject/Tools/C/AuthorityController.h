//
//  AuthorityController.h
//  CommunityProject
//
//  Created by bjike on 2017/6/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityRecommendController.h"

@interface AuthorityController : UIViewController
//朋友圈权限
@property (nonatomic,assign)ActivityRecommendController * delegate;

@end
