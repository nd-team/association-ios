//
//  WordsDetailController.h
//  CommunityProject
//
//  Created by bjike on 2017/8/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SendRaiseController.h"

@interface WordsDetailController : UIViewController
//标题
@property (nonatomic,copy)NSString * name;
//提示语
@property (nonatomic,copy)NSString * place;

@property (nonatomic,assign)SendRaiseController * delegate;


@end
