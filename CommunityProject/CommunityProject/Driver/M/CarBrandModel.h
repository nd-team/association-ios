//
//  CarBrandModel.h
//  CommunityProject
//
//  Created by bjike on 2017/8/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SonModel <NSObject>



@end
@interface SonModel : JSONModel
@property (nonatomic,copy)NSString * car;
@property (nonatomic,copy)NSString * type;

@end
@interface CarBrandModel : JSONModel
@property (nonatomic,copy)NSString * name;
@property (nonatomic,strong)NSArray <SonModel>* son;

@end
