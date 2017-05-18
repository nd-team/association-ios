//
//  PlatformActListModel.h
//  CommunityProject
//
//  Created by bjike on 17/5/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PlatformActListModel : JSONModel
//平台活动图片
@property (nonatomic,copy) NSString * activesImage;
//活动标题
@property (nonatomic,copy) NSString * title;
//活动地址
@property (nonatomic,copy) NSString * address;

//1进行中0已截止
@property (nonatomic,copy) NSString * status;
//活动ID
@property (nonatomic) NSInteger  id;

@end
