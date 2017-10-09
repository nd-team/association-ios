//
//  DriverGrobListModel.m
//  CommunityProject
//
//  Created by bjike on 2017/8/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "DriverGrobListModel.h"

@implementation DriverGrobListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"idStr":@"id"}];
}
@end
