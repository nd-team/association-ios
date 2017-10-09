//
//  HelpDetailController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpDetailController : UIViewController

@property (nonatomic,copy)NSString * titleStr;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * answerCount;
@property (nonatomic,copy)NSString * contributeCount;
@property (nonatomic,copy)NSString * time;
//求助用户ID
@property (nonatomic,copy)NSString * hostId;

//文章ID
@property (nonatomic,copy)NSString * iDStr;

@property (nonatomic,assign)BOOL isRef;

@end
