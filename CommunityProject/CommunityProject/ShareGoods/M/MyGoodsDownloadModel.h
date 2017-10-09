//
//  MyGoodsDownloadModel.h
//  CommunityProject
//
//  Created by bjike on 2017/7/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyGoodsDownloadModel : JSONModel
//标题
@property (nonatomic,copy) NSString * title;
//大小
@property (nonatomic,copy) NSString * kbStr;
//类型
@property (nonatomic,copy) NSString * type;

//时间
@property (nonatomic,copy)NSString * time;
//文件流
@property (nonatomic,strong)NSData * data;

@end
