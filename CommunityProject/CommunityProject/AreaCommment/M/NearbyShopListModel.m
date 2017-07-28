//
//  NearbyShopListModel.m
//  CommunityProject
//
//  Created by bjike on 2017/7/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "NearbyShopListModel.h"

@implementation NearbyShopListModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"idStr":@"id"}];
}
@end
