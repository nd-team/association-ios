//
//  MyLocationViewController.h
//  CommunityProject
//
//  Created by bjike on 17/5/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateActivityController.h"

@protocol MapLocationPickerViewControllerDelegate <NSObject>

/**
 *  通知delegate，已经获取到相关的地理位置信息
 *
 *  @param locationPicker locationPicker
 *  @param location       location
 *  @param locationName   locationName
 *  @param mapScreenShot  mapScreenShot
 */
//:(MyLocationViewController *)locationPicker
-(void)locationDidSelectLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName mapScreenShot:(UIImage *)mapScreenShot;

@end
@interface MyLocationViewController : UIViewController
@property (nonatomic,assign)CreateActivityController * actDelegate;
//创建活动
@property (nonatomic,assign)BOOL isAct;
//地址
@property (nonatomic,copy)NSString * area;
//经纬度
@property (nonatomic,assign)CGFloat longitude;
@property (nonatomic,assign)CGFloat latitute;
//代理方法实现位置信息发送
@property(nonatomic, weak) id<MapLocationPickerViewControllerDelegate> delegate;
//标记是否点击搜索的取消
@property (nonatomic,assign)BOOL isCancle;

@end
