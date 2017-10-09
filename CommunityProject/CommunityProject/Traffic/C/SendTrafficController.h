//
//  SendTrafficController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficListController.h"

@interface SendTrafficController : UIViewController

@property (nonatomic,copy)NSString * authStr;

@property (nonatomic,assign)TrafficListController * delegate;
@property (nonatomic,copy)NSString * userId;

@end
