//
//  TravelModel.h
//  CommunityProject
//
//  Created by bjike on 17/5/4.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TravelModel : JSONModel
//平台活动图片
@property (nonatomic,copy) NSString * activesImage;
//活动标题
@property (nonatomic,copy) NSString * title;
//活动地址
@property (nonatomic,copy) NSString * address;

@end
