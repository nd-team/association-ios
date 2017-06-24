//
//  SendEducationController.h
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EducationListController.h"

@interface SendEducationController : UIViewController

@property (nonatomic,copy)NSString * authStr;

@property (nonatomic,copy)NSString * userId;

@property (nonatomic,assign)EducationListController * delegate;

@end
