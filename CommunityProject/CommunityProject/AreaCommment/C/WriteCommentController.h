//
//  WriteCommentController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/21.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteCommentController : UIViewController
@property (nonatomic,copy)NSString * shopname;
@property (nonatomic,copy)NSString * areaId;
//经度
@property (nonatomic,assign)CGFloat  longitude;
//纬度
@property (nonatomic,assign)CGFloat  latitude;
//地址
@property (nonatomic,copy)NSString * area;

@end
