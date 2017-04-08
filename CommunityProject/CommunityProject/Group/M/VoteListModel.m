//
//  VoteListModel.m
//  CommunityProject
//
//  Created by bjike on 17/4/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VoteListModel.h"

@implementation OptionModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
//如果有json的key和模型的属性名不一致，则利用该方法重新赋值
+(JSONKeyMapper *)keyMapper{
    //字典的key为json的key，字典的值，为模型的属性名。
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"id":@"idStr"}];
}
@end
@implementation VoteListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
