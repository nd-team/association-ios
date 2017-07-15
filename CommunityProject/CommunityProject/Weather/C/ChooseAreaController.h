//
//  ChooseAreaController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherListController.h"

@interface ChooseAreaController : UIViewController

@property (nonatomic,assign)WeatherListController * delegate;

@property (nonatomic,copy)NSString * area;

@end
