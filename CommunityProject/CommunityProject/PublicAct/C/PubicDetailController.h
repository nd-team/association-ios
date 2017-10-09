//
//  PubicDetailController.h
//  CommunityProject
//
//  Created by bjike on 17/5/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PubicDetailController : UIViewController
//文章ID
@property (nonatomic,copy)NSString * idStr;

//用户头像
@property (nonatomic,strong)NSString * headUrl;
//内容
@property (nonatomic,strong)NSString * titleName;

@end
