//
//  AppCenterController.h
//  CommunityProject
//
//  Created by bjike on 17/3/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstController.h"

@interface AppCenterController : UIViewController

@property (nonatomic,assign)FirstController * delegate;

@property (nonatomic,strong)NSMutableArray * nameArr;

@end
