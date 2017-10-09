//
//  SendGoodsController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListController.h"

@interface SendGoodsController : UIViewController
@property (nonatomic,copy)NSString * authStr;
@property (nonatomic,copy)NSString * downStr;

@property (nonatomic,assign)GoodsListController * delegate;
@property (nonatomic,copy)NSString * userId;

@end
