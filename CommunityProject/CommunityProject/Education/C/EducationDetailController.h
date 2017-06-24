//
//  EducationDetailController.h
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EducationDetailController : UIViewController
//传参过来
@property (nonatomic,copy)NSString * userId;
@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,copy)NSString * headUrl;
@property (nonatomic,copy)NSString * topic;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * content;
//获取视频第一帧和视频的二进制流
@property (nonatomic,strong)UIImage * firstImg;
@property (nonatomic,strong)NSData *videoData;
//本地视频地址
@property (nonatomic,strong)NSURL * localUrl;
//网络加载
@property (nonatomic,copy)NSString * videoUrl;
@property (nonatomic,copy)NSString * firstUrl;
@property (nonatomic,copy)NSString * commentNum;
@property (nonatomic,copy)NSString * shareNum;
@property (nonatomic,copy)NSString * loveNum;
@property (nonatomic,copy)NSString * downloadNum;
@property (nonatomic,copy)NSString * collNum;
@property (nonatomic,assign)BOOL  isLove;
@property (nonatomic,assign)BOOL  isCollect;
@property (nonatomic,copy)NSString * idStr;
//标记是否为预览
@property (nonatomic,assign)BOOL isLook;
//权限
@property (nonatomic,copy)NSString * authStatus;
//视频时长
@property (nonatomic,copy)NSString * videoTime;
//是否是从我的下载界面PUSH过来
@property (nonatomic,assign)BOOL isDown;
//头像二进制
@property (nonatomic,strong)NSData *headData;

@end
