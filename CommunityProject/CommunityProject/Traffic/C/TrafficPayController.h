//
//  TrafficPayController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficDetailController.h"

@interface TrafficPayController : UIViewController
@property (nonatomic,copy)NSString *dealContribution;

@property (nonatomic,copy)NSString * content;

@property (nonatomic,copy)NSString * headUrl;

@property (nonatomic,copy)NSString * articalId;

@property (nonatomic,copy)NSString * userId;

@property (nonatomic,assign)TrafficDetailController  *delegate;

@end
