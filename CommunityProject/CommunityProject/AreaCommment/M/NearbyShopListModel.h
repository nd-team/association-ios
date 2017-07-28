//
//  NearbyShopListModel.h
//  CommunityProject
//
//  Created by bjike on 2017/7/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NearbyShopListModel : JSONModel
//地址
@property (nonatomic,strong)NSString * address;
//纬度
@property (nonatomic,strong)NSString * pointX;
//经度
@property (nonatomic,strong)NSString * pointY;
//店铺名
@property (nonatomic,strong)NSString * name;
//地点坐标
@property (nonatomic,strong)NSString * pointId;
//图片
@property (nonatomic,strong)NSArray * images;
//ID
@property (nonatomic,assign)NSInteger  idStr;

@end
