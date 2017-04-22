//
//  ActivityRecommendController.h
//  CommunityProject
//
//  Created by bjike on 17/4/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateActivityController.h"
#import "CircleOfListController.h"

@interface ActivityRecommendController : UIViewController

@property (nonatomic,assign)CreateActivityController * delegate;
@property (nonatomic,assign)CircleOfListController * circleDelegate;

//标题
@property (nonatomic,copy)NSString * name;
//右侧按钮名字
@property (nonatomic,copy)NSString * rightStr;
//区分1：活动介绍2：发布朋友圈
@property (nonatomic,assign)int type;


@end
