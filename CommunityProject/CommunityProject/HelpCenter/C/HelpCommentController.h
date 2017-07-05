//
//  HelpCommentController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/5.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpCommentController : UIViewController
@property (nonatomic,copy)NSString * titleStr;
@property (nonatomic,copy)NSString * nameStr;
@property (nonatomic,copy)NSString * headUrl;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * comment;
@property (nonatomic,copy)NSString * loveCount;
//文章ID
@property (nonatomic,copy)NSString * actiId;
//评论ID
@property (nonatomic,copy)NSString * answerId;
//发求助的人ID
@property (nonatomic,copy)NSString * hostId;

@end
