//
//  DriverReceivableController.h
//  CommunityProject
//
//  Created by bjike on 2017/8/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverReceivableController : UIViewController
@property (nonatomic,copy)NSString * orderId;
@property (nonatomic,copy)NSString * startArea;
@property (nonatomic,copy)NSString * endArea;
@property (nonatomic,copy)NSString * phone;
@property (nonatomic,copy)NSString * money;
@property (nonatomic,copy)NSString * headUrl;
//乘客那边高德计算的里程
@property (nonatomic,copy)NSString * kilomile;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * timeCha;
//运动里程
@property (nonatomic,copy)NSString * motionKilo;

@end
