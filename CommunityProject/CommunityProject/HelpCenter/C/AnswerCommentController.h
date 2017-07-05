//
//  AnswerCommentController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/5.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpDetailController.h"

@interface AnswerCommentController : UIViewController
//文章ID
@property (nonatomic,copy)NSString * actID;
@property (nonatomic,assign)HelpDetailController * delegate;

@end
