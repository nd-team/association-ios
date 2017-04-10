//
//  MyLocationViewController.h
//  CommunityProject
//
//  Created by bjike on 17/3/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "CreateActivityController.h"

@interface MyLocationViewController : RCLocationPickerViewController

@property (nonatomic,assign)CreateActivityController * actDelegate;

@end
