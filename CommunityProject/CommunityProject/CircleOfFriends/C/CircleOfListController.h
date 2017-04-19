//
//  CircleOfListController.h
//  CommunityProject
//
//  Created by bjike on 17/4/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListModel.h"

@interface CircleOfListController : UIViewController
//插入一个cell
@property (nonatomic,assign)BOOL isRef;
//@property (nonatomic,strong)CircleListModel * model;
//消息数据
@property (nonatomic,strong)NSArray * msgArr;
@property (nonatomic,copy)NSString * countStr;
@end
