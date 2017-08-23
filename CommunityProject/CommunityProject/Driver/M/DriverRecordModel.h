//
//  DriverRecordModel.h
//  CommunityProject
//
//  Created by bjike on 2017/8/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DriverRecordModel : JSONModel
@property (nonatomic,copy)NSString * orderId;
@property (nonatomic,copy)NSString * fromAddress;
@property (nonatomic,copy)NSString * destination;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * money;
//0未开始1进行中2已完成3取消4司机已接单未接到乘客5司机完成
@property (nonatomic,copy)NSString * status;

@end
