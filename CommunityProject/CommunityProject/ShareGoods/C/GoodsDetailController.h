//
//  GoodsDetailController.h
//  CommunityProject
//
//  Created by bjike on 2017/7/11.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailController : UIViewController

@property (nonatomic,assign)BOOL isLook;

@property (nonatomic,copy) NSString * titleStr;

@property (nonatomic,copy)NSString * backUrl;

@property (nonatomic,copy)NSString * nickname;

@property (nonatomic,copy)NSString * headUrl;

@property (nonatomic,copy)NSString * content;

@property (nonatomic,copy)NSString * idStr;

@property (nonatomic,copy)NSString * likes;

@property (nonatomic,copy)NSString * time;

@property (nonatomic,copy)NSString * shareNum;

@property (nonatomic,copy)NSString * commentNum;
@property (nonatomic,copy)NSString * downloadNum;
@property (nonatomic,copy)NSString * collectNum;

@property (nonatomic,assign)BOOL isLove;

//预览需要的数据
@property (nonatomic,strong)UIImage * backImage;

@property (nonatomic,strong)UIImage * buyImage;

@property (nonatomic,copy)NSString * buyContent;
//权限状态
@property (nonatomic,copy)NSString * status;

@property (nonatomic,copy)NSString * isDown;

@end
