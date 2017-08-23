//
//  DriverGrobListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/8/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DriverGrobListModel : JSONModel
@property (nonatomic,copy)NSString * mobile;
@property (nonatomic,copy)NSString * userPortraitUrl;
@property (nonatomic,copy)NSString * userName;

@property (nonatomic,copy)NSString * fromDegree;
@property (nonatomic,copy)NSString * fromAddress;
@property (nonatomic,copy)NSString * destination;
@property (nonatomic,copy)NSString * kilometre;
@property (nonatomic,copy)NSString * money;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * longitude;
@property (nonatomic,copy)NSString * latitude;
@property (nonatomic,copy)NSString * idStr;

@end
