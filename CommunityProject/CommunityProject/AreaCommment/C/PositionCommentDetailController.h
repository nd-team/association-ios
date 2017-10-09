//
//  PositionCommentDetailController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionCommentDetailController : UIViewController
//传参
@property (nonatomic,copy)NSString * headUrl;
@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * score;
@property (nonatomic,copy)NSString * comment;
@property (nonatomic,strong)NSMutableArray * collectArr;;
@property (nonatomic,assign)BOOL isLove;
@property (nonatomic,copy)NSString * commentId;

@end
