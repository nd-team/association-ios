//
//  CreateActivityController.h
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupActivityListController.h"

@interface CreateActivityController : UIViewController
@property (nonatomic,copy)NSString * groupID;
@property (nonatomic,copy)NSString * userID;
//活动名称
@property (nonatomic,strong)NSString *name;
//活动限制人数
@property (nonatomic,strong)NSString * limitPeople;

@property (nonatomic,strong)NSMutableArray * dataArr;

@property (nonatomic,copy)NSString * area;

@property (nonatomic,copy)NSString * recommendStr;

@property (nonatomic,assign)GroupActivityListController * delegate;

@end
