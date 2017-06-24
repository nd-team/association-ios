//
//  ManagerDownloadController.h
//  CommunityProject
//
//  Created by bjike on 2017/6/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerDownloadController : UIViewController

@property (nonatomic,copy)NSString * topic;

@property (nonatomic,assign)NSInteger progress;

@property (nonatomic,strong)NSURLSessionDownloadTask * downloadTask;

@end
