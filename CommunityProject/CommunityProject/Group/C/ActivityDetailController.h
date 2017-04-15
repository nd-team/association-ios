//
//  ActivityDetailController.h
//  LoveChatProject
//
//  Created by bjike on 17/2/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupActivityListController.h"

@interface ActivityDetailController : UIViewController

@property (nonatomic,copy)NSString * titleStr;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * area;
@property (nonatomic,copy)NSString * recomend;
@property (nonatomic,copy)NSString * actives_id;
@property (nonatomic,copy)NSString * headStr;
//是否报名
@property (nonatomic,assign)BOOL isSign;
//活动是否结束
@property (nonatomic,assign)BOOL isOver;

@property (nonatomic,assign)GroupActivityListController * listDelegate;

@end
