//
//  RaiseListModel.m
//  CommunityProject
//
//  Created by bjike on 2017/7/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "RaiseListModel.h"

@implementation RaiseListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"idStr":@"id"}];
}
@end
