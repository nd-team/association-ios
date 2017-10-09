//
//  CircleCommentController.h
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleCommentController : UIViewController
@property (nonatomic,copy)NSString * headUrl;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,strong)NSArray * collectionArr;
@property (nonatomic,copy)NSString * commentCount;
@property (nonatomic,copy)NSString * likeCount;
@property (nonatomic,copy)NSString * isLike;
//说说ID
@property (nonatomic,copy)NSString * idStr;
//placeHolder
@property (nonatomic,copy)NSString * placeStr;
//评论ID
@property (nonatomic,copy)NSString *commentId;
//消息push进来的界面
@property (nonatomic,assign)BOOL isMsg;

@end
