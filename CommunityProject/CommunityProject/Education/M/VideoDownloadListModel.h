//
//  VideoDownloadListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/6/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @enum 下载状态
 */
typedef NS_ENUM(NSUInteger, DownloadState) {
    /* 等待下载 */
    DownloadStateWait,
    /* 正在下载 */
    DownloadStateLoading,
    /* 下载暂停 */
    DownloadStatePaused,
    /* 下载完成 */
    DownloadStateComplete,
    /* 下载失败 */
    DownloadStateError,
};

@interface VideoDownloadListModel :NSObject
//文章ID
@property (nonatomic,copy) NSString * activesId;
//视频
@property (nonatomic,strong) NSData * videoData;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,strong) NSData * headImage;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,strong) NSData * firstImage;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * likesStatus;
@property (nonatomic,copy) NSString * checkCollect;
//时间排序
@property (nonatomic,copy) NSString * time;
@property (nonatomic,copy) NSString * mbStr;
//视频地址
@property (nonatomic,copy) NSString * videoUrl;
//视频下载状态
@property (assign, nonatomic) DownloadState downloadState;

@end
