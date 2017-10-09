//
//  PlatformCommentController.h
//  CommunityProject
//
//  Created by bjike on 17/5/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformCommentController : UIViewController
//6:平台活动7公益活动1产品众筹2朋友圈3干货分享4求助中心5灵感贩卖6平台活动7公益活动  9三分钟教学
@property (nonatomic,assign)int type;
//Id
@property (nonatomic,copy)NSString * idStr;
//用户头像
@property (nonatomic,strong)NSString * headUrl;
//标题
@property (nonatomic,strong)NSString * content;

@end
