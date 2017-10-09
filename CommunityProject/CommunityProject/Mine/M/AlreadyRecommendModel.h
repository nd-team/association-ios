//
//  AlreadyRecommendModel.h
//  CommunityProject
//
//  Created by bjike on 17/4/26.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AlreadyRecommendModel : JSONModel
//真实姓名
@property (nonatomic,strong)NSString * fullName;
//电话
@property (nonatomic,strong)NSString * mobile;
//推荐码
@property (nonatomic,strong)NSString * recommendId;

@end
